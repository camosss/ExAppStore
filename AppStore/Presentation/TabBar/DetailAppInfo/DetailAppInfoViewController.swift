//
//  DetailAppInfoViewController.swift
//  AppStore
//
//  Created by 강호성 on 4/1/24.
//

import UIKit

final class DetailAppInfoViewController: BaseViewController {

    // MARK: - Properties

    private let appInfo: AppInfo

    // MARK: - Init
    
    init(appInfo: AppInfo) {
        self.appInfo = appInfo
        print(appInfo)
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
    }

    override func setConstraints() {
        super.setConstraints()
    }

    override func setConfigurations() {
        super.setConfigurations()
    }
}
