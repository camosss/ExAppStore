//
//  BaseTableViewHeaderFooterView.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import UIKit

class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setViews()
        setConstraints()
        setConfigurations()
    }

    required init?(coder: NSCoder) {
        fatalError("ProfileHeaderView: fatal error")
    }

    func setViews() {}
    func setConstraints() {}
    func setConfigurations() {}
}
