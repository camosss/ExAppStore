//
//  SearchResultsViewController.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import UIKit

final class SearchResultsViewController: BaseViewController {

    // MARK: - Properties

    let tableView = UITableView()

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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        tableView.register(
            SearchingStateTableViewCell.self,
            forCellReuseIdentifier: SearchingStateTableViewCell.reuseIdentifier
        )
        tableView.register(
            SearchCompletedTableViewCell.self,
            forCellReuseIdentifier: SearchCompletedTableViewCell.reuseIdentifier
        )
    }
}
