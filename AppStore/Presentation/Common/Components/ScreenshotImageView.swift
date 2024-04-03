//
//  ScreenshotImageView.swift
//  AppStore
//
//  Created by 강호성 on 4/1/24.
//

import UIKit

final class ScreenshotImageView: UIImageView {

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Helpers

    private func setupView() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.systemGray6.cgColor
        self.layer.borderWidth = 1
        self.contentMode = .scaleAspectFill
    }
}
