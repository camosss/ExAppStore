//
//  SearchCompletedTableViewCell.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import UIKit

final class SearchCompletedTableViewCell: BaseTableViewCell<AppInfo> {

    // MARK: - Properties

    private lazy var containerView: UIView = {
        let view = UIView()
        view.addSubview(iconImageView)
        view.addSubview(infoContainerStackView)
        view.addSubview(buttonContainerView)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.systemGray6.cgColor
        imageView.layer.borderWidth = 1
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var infoContainerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameLabel,
            descriptionLabel,
            rateInfoContainerStackView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()

    private lazy var rateInfoContainerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            starRatingView,
            ratingCountLabel,
            emptyView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 2
        return stackView
    }()
    private let starRatingView: StarRatingView = {
        let view = StarRatingView()
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return view
    }()
    private let ratingCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    private let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var buttonContainerView: UIView = {
        let view = UIView()
        view.addSubview(buttonSpacingView)
        view.addSubview(receiveButton)
        return view
    }()
    private let buttonSpacingView = UIView()
    private let receiveButton: UIButton = {
        let button = UIButton()
        button.setTitle("받기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = .systemGray6
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        return button
    }()

    private lazy var screenshotImageViews: [ScreenshotImageView] = {
        var views = [ScreenshotImageView]()
        for _ in 0..<3 {
            let imageView = ScreenshotImageView()
            views.append(imageView)
        }
        return views
    }()
    private lazy var screenshotImageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: screenshotImageViews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()

    // MARK: - Helpers

    override func setViews() {
        super.setViews()
        contentView.addSubview(containerView)
        contentView.addSubview(screenshotImageStackView)
    }

    override func setConstraints() {
        super.setConstraints()
        containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(24)
        }
        screenshotImageStackView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview().inset(24)
            make.height.equalTo(200)
        }
        iconImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(48)
        }
        infoContainerStackView.snp.makeConstraints { make in
            make.top.equalTo(4)
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
            make.bottom.equalToSuperview()
        }
        buttonContainerView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(infoContainerStackView.snp.trailing).offset(16)
        }
        buttonSpacingView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        receiveButton.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.leading.equalTo(buttonSpacingView.snp.trailing)
            make.width.equalTo(62)
            make.height.equalTo(24)
        }
    }

    override func bind(_ model: AppInfo?) {
        super.bind(model)

        if let iconImage = model?.artworkUrl512 {
            iconImageView.loadImage(with: iconImage)
        }
        if let name = model?.trackName {
            nameLabel.setTextWithLineHeight(text: name, lineHeight: 16)
        }
        if let description = model?.description {
            descriptionLabel.setTextWithLineHeight(text: description, lineHeight: 14)
        }
        if let averageUserRating = model?.averageUserRating {
            starRatingView.setupStarFills(averageUserRating)
            starRatingView.isHidden = (averageUserRating == 0)
        }
        if let userRatingCount = model?.userRatingCount {
            ratingCountLabel.text = userRatingCount.formattedString
            ratingCountLabel.isHidden = (userRatingCount == 0)
        }

        if let screenshotUrls = model?.screenshotUrls {
            for (index, imageView) in screenshotImageViews.enumerated() {
                if index < screenshotUrls.count {
                    imageView.loadImage(with: screenshotUrls[index])
                }
            }
        }
    }
}
