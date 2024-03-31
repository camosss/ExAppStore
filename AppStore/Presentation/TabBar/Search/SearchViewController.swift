//
//  SearchViewController.swift
//  AppStore
//
//  Created by 강호성 on 3/30/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

final class SearchViewController: BaseViewController {

    // MARK: - Properties

    let resultsViewController = SearchResultsViewController()
    lazy var searchController = UISearchController(
        searchResultsController: resultsViewController
    )
    private let tableView = UITableView()

    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()

    private lazy var input = SearchViewModel.Input(
        searchBarTerm: searchController.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .asSignal(onErrorJustReturn: "")
    )
    private lazy var output = viewModel.transform(input: input)

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
        tableView.dataSource = self
        tableView.delegate = self
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
        output.appInfos
            .asDriver()
            .drive()
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 10
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: RecentSearchTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! RecentSearchTableViewCell
        cell.bind("최근 검색어")
        return cell
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
