//
//  EmptyView.swift
//  AppStore
//
//  Created by 강호성 on 4/2/24.
//

import UIKit

final class EmptyView: UIView {

    // MARK: - Properties

    private var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Initializer

    convenience init(frame: CGRect, text: String) {
        self.init(frame: frame)
        setViews()
        setConstraints()

        self.textLabel.text = text
    }

    // MARK: - Helpers

    private func setViews() {
        addSubview(textLabel)
    }

    private func setConstraints() {
        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
