//
//  SearchResultsTableViewCell.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import UIKit

final class SearchResultsTableViewCell: BaseTableViewCell<String> {

    // MARK: - Properties

    private let iconImageView = UIImageView()
    private let searchResultsLabel = UILabel()

    // MARK: - Helpers

    override func setViews() {
        super.setViews()
        contentView.addSubview(iconImageView)
        contentView.addSubview(searchResultsLabel)
    }

    override func setConstraints() {
        super.setConstraints()
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(16)
        }
        searchResultsLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(20)
        }
    }

    override func setConfigurations() {
        super.setConfigurations()
        iconImageView.tintColor = .systemGray

        searchResultsLabel.textColor = .label
        searchResultsLabel.font = UIFont.systemFont(ofSize: 14)
    }

    override func bind(_ model: String?) {
        super.bind(model)
        iconImageView.image = UIImage(systemName: "magnifyingglass")
        searchResultsLabel.text = model
    }
}
