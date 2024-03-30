//
//  SearchResultsViewController.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import UIKit

final class SearchResultsViewController: BaseViewController {

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
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(
            SearchResultsTableViewCell.self,
            forCellReuseIdentifier: SearchResultsTableViewCell.reuseIdentifier
        )
    }
}

// MARK: - UITableViewDataSource
extension SearchResultsViewController: UITableViewDataSource {
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
            withIdentifier: SearchResultsTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! SearchResultsTableViewCell
        cell.bind("검색 결과")
        return cell
    }
}
