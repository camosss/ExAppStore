//
//  SearchViewController.swift
//  AppStore
//
//  Created by 강호성 on 3/30/24.
//

import UIKit

import SnapKit
import RxDataSources
import RxCocoa
import RxSwift

final class SearchViewController: BaseViewController {

    // MARK: - Properties

    private let resultsViewController = SearchResultsViewController()
    private lazy var searchController = UISearchController(
        searchResultsController: resultsViewController
    )
    private let tableView = UITableView(frame: .zero, style: .grouped)

    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()

    private lazy var input = SearchViewModel.Input(
        viewDidLoad: Observable.just(()),
        searchBarTerm: searchController.searchBar
            .rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .asSignal(onErrorJustReturn: ""),
        searchItemDidTap: resultsViewController.tableView
            .rx.itemSelected
            .map{ $0.row }.asSignal(onErrorJustReturn: -1),
        shouldLoadResult: searchController.searchBar
            .rx.searchButtonClicked.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)

    private lazy var recentTermDataSource = RxTableViewSectionedReloadDataSource<
        RecentTermModelSection.RecentTermModelSectionModel
    >(configureCell: { dataSource, tableView, indexPath, item in
        switch item {
        case .firstItem(let recentTermModel):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: RecentSearchTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! RecentSearchTableViewCell
            cell.bind(recentTermModel.term)
            return cell
        }
    })

    private lazy var searchDataSource = RxTableViewSectionedReloadDataSource<
        SearchResultSection.SearchResultSectionModel
    >(configureCell: { dataSource, tableView, indexPath, item in
        switch item {
        case .searchingState(let appInfo):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchingStateTableViewCell.reuseIdentifier
            ) as! SearchingStateTableViewCell
            cell.bind(appInfo.trackName)
            return cell

        case .searchCompleted(let appInfo):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchCompletedTableViewCell.reuseIdentifier
            ) as! SearchCompletedTableViewCell
            cell.bind(appInfo)
            return cell
        }
    })

    // MARK: - Init

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("InvestViewController fatal error")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    // MARK: - Helpers

    override func setViews() {
        super.setViews()
        view.addSubview(tableView)
    }

    override func setConstraints() {
        super.setConstraints()
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func setConfigurations() {
        super.setConfigurations()
        title = "검색"

        setSearchController()
        setTableView()
    }

    private func setSearchController() {
        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func setTableView() {
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(
            RecentSearchHeaderView.self,
            forHeaderFooterViewReuseIdentifier: RecentSearchHeaderView.reuseIdentifier
        )
        tableView.register(
            RecentSearchTableViewCell.self,
            forCellReuseIdentifier: RecentSearchTableViewCell.reuseIdentifier
        )
    }
}

// MARK: - Bind
extension SearchViewController {
    private func bind() {
        output.recentTerms
            .map { return $0.count <= 0 }
            .bind(to: tableView.rx.isEmptyTableView(text: "최근 검색어가 없습니다."))
            .disposed(by: disposeBag)

        output.recentTerms
            .asDriver()
            .map { value in
                return [RecentTermModelSection.RecentTermModelSectionModel(
                    model: 0,
                    items: value.map { .firstItem($0) }
                )]
            }
            .drive(tableView.rx.items(dataSource: recentTermDataSource))
            .disposed(by: disposeBag)

        output.sections
            .asDriver()
            .drive(resultsViewController.tableView.rx.items(dataSource: searchDataSource))
            .disposed(by: disposeBag)

        output.isEditingSearchBar
            .asDriver()
            .drive(onNext: { [weak self] isEditing in
                guard let self = self,
                      !isEditing
                else { return }

                self.searchController.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)

        output.currentTerm
            .asDriver()
            .filter({ !$0.isEmpty })
            .drive(onNext: { [weak self] term in
                guard let self = self else { return }
                self.searchController.searchBar.text = term
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        return RecentSearchHeaderView()
    }
}
