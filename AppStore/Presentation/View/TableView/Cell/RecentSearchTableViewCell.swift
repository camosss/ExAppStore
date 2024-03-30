//
//  RecentSearchTableViewCell.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import UIKit

final class RecentSearchTableViewCell: BaseTableViewCell<String> {

    // MARK: - Properties

    private let recentSearchLabel = UILabel()

    // MARK: - Helpers

    override func setViews() {
        super.setViews()
        contentView.addSubview(recentSearchLabel)
    }

    override func setConstraints() {
        super.setConstraints()
        recentSearchLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    override func setConfigurations() {
        super.setConfigurations()
        recentSearchLabel.textColor = .systemBlue
    }
    
    override func bind(_ model: String?) {
        super.bind(model)
        recentSearchLabel.text = model
    }
}
