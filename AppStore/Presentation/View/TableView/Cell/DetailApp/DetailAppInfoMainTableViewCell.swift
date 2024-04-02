//
//  DetailAppInfoMainTableViewCell.swift
//  AppStore
//
//  Created by 강호성 on 4/1/24.
//

import UIKit

final class DetailAppInfoMainTableViewCell: BaseTableViewCell<AppInfo> {

    // MARK: - Properties

    private lazy var containerView: UIView = {
        let view = UIView()
        view.addSubview(iconImageView)
        view.addSubview(nameStackView)
        view.addSubview(receiveButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.borderColor = UIColor.systemGray6.cgColor
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, sellerNameLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    private let sellerNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    private let receiveButton: UIButton = {
        let button = UIButton()
        button.setTitle("받기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = .systemBlue
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        return button
    }()
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()

    // MARK: - Helpers

    override func setViews() {
        super.setViews()
        addSubview(containerView)
        addSubview(dividerView)
    }

    override func setConstraints() {
        super.setConstraints()
        containerView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        iconImageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.size.equalTo(100)
        }
        nameStackView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
        }
        receiveButton.snp.makeConstraints { make in
            make.top.equalTo(nameStackView.snp.bottom).priority(.low)
            make.leading.equalTo(nameStackView)
            make.bottom.equalToSuperview()
            make.width.equalTo(62)
            make.height.equalTo(24)
        }
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(16)
            make.leading.equalTo(24)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    override func bind(_ model: AppInfo?) {
        super.bind(model)
        if let iconImage = model?.artworkUrl512 {
            iconImageView.loadImage(with: iconImage)
        }
        if let name = model?.trackName {
            nameLabel.text = name
        }
        if let sellerName = model?.sellerName {
            sellerNameLabel.text = sellerName
        }
    }
}
