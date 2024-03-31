//
//  SearchViewController.swift
//  AppStore
//
//  Created by 강호성 on 3/30/24.
//

import UIKit
import SnapKit

final class SearchViewController: BaseViewController {

    // MARK: - Properties

    private let tableView = UITableView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
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
        let resultsViewController = SearchResultsViewController()
        let searchController = UISearchController(
            searchResultsController: resultsViewController
        )

        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
        searchController.searchResultsUpdater = self
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

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        dump(text)
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
