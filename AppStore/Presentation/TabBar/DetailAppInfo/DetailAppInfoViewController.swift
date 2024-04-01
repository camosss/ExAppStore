//
//  DetailAppInfoViewController.swift
//  AppStore
//
//  Created by 강호성 on 4/1/24.
//

import UIKit

enum DetailAppInfoViewType: Int, CaseIterable {
    case main
    case description
    case screenshot
}

final class DetailAppInfoViewController: BaseViewController {

    // MARK: - Properties

    private var appInfo: AppInfo

    private let tableView = UITableView()

    // MARK: - Init

    init(appInfo: AppInfo) {
        self.appInfo = appInfo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        setTableView()
    }

    private func setTableView() {
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(
            DetailAppInfoMainTableViewCell.self,
            forCellReuseIdentifier: DetailAppInfoMainTableViewCell.reuseIdentifier
        )
        tableView.register(
            DetailAppInfoDescriptionTableViewCell.self,
            forCellReuseIdentifier: DetailAppInfoDescriptionTableViewCell.reuseIdentifier
        )
        tableView.register(
            DetailAppInfoScreenshotListTableViewCell.self,
            forCellReuseIdentifier: DetailAppInfoScreenshotListTableViewCell.reuseIdentifier
        )
    }
}

// MARK: - UITableViewDataSource
extension DetailAppInfoViewController: UITableViewDataSource {
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return DetailAppInfoViewType.allCases.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 1
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let sectionType = DetailAppInfoViewType(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        switch sectionType {
        case .main:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DetailAppInfoMainTableViewCell.reuseIdentifier
            ) as! DetailAppInfoMainTableViewCell
            cell.bind(appInfo)
            return cell

        case .description:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DetailAppInfoDescriptionTableViewCell.reuseIdentifier
            ) as! DetailAppInfoDescriptionTableViewCell
            cell.delegate = self
            cell.bind(appInfo)
            return cell

        case .screenshot:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: DetailAppInfoScreenshotListTableViewCell.reuseIdentifier
            ) as! DetailAppInfoScreenshotListTableViewCell
            cell.bind(appInfo.screenshotUrls)
            return cell
        }
    }
}

// MARK: - DetailAppInfoDescriptionTableViewCellDelegate
extension DetailAppInfoViewController: DetailAppInfoDescriptionTableViewCellDelegate {
    func moreButtonDidTap() {
        tableView.reloadData()
    }
}
