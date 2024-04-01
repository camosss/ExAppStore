//
//  ScreenshotListCollectionViewCell.swift
//  AppStore
//
//  Created by 강호성 on 4/2/24.
//

import UIKit

final class ScreenshotListCollectionViewCell: BaseCollectionViewCell<String> {

    // MARK: - Properties

    private let screenshotImageView = ScreenshotImageView()

    // MARK: - Helpers

    override func setViews() {
        super.setViews()
        contentView.addSubview(screenshotImageView)
    }

    override func setConstraints() {
        super.setConstraints()
        screenshotImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func bind(_ model: String?) {
        super.bind(model)

        if let model = model {
            screenshotImageView.loadImage(with: model)
        }
    }
}
