//
//  DetailAppInfoViewController.swift
//  AppStore
//
//  Created by 강호성 on 4/1/24.
//

import UIKit

import RxDataSources
import RxCocoa
import RxSwift

final class DetailAppInfoViewController: BaseViewController {

    // MARK: - Properties

    private let appInfo: AppInfo

    private let tableView = UITableView()

    private let disposeBag = DisposeBag()

    private lazy var dataSource = RxTableViewSectionedReloadDataSource<
        DetailAppInfoSection.DetailAppInfoSectionModel
    >(configureCell: { dataSource, tableView, indexPath, item in
        switch item {
        case .screenshot(let appInfo):
            return UITableViewCell()

        case .description(let appInfo):
            return UITableViewCell()
        }
    })

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
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(
            DetailAppInfoHeaderView.self,
            forHeaderFooterViewReuseIdentifier: DetailAppInfoHeaderView.reuseIdentifier
        )
    }
}

// MARK: - UITableViewDelegate
extension DetailAppInfoViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let headerView = DetailAppInfoHeaderView()
        headerView.bind(appInfo)
        return headerView
    }
}
