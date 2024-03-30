//
//  RecentSearchHeaderView.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import UIKit

final class RecentSearchHeaderView: BaseTableViewHeaderFooterView {

    // MARK: - Properties

    private let titleLabel = UILabel()

    // MARK: - Helpers

    override func setViews() {
        super.setViews()
        addSubview(titleLabel)
    }

    override func setConstraints() {
        super.setConstraints()
        titleLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalTo(20)
            make.bottom.equalToSuperview().inset(8)
        }
    }

    override func setConfigurations() {
        super.setConfigurations()
        titleLabel.text = "최근 검색어"
        titleLabel.textColor = .label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
    }
}
