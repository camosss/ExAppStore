//
//  StarRatingView.swift
//  AppStore
//
//  Created by 강호성 on 4/2/24.
//

import UIKit

final class StarRatingView: BaseView {

    // MARK: - Properties

    private var endNumber: Int = 5

    private let starFillImage: UIImage? = {
        return UIImage(systemName: "star.fill")?
            .resized(to: CGSize(width: 12, height: 12))
            .withTintColor(.systemGray3)
    }()
    private let starLeadingHalfImage: UIImage? = {
        return UIImage(systemName: "star.leadinghalf.filled")?
            .resized(to: CGSize(width: 12, height: 12))
            .withTintColor(.systemGray3)
    }()
    private let starEmptyImage: UIImage? = {
        return UIImage(systemName: "star")?
            .resized(to: CGSize(width: 12, height: 12))
            .withTintColor(.systemGray3)
    }()

    private var buttons: [UIButton] = []

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .leading
        return view
    }()

    // MARK: - Helpers

    override func setViews() {
        super.setViews()
        addSubview(stackView)
    }

    override func setConstraints() {
        super.setConstraints()
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func setConfigurations() {
        super.setConfigurations()

        for _ in 0..<endNumber {
            let button = UIButton()
            button.setImage(starEmptyImage, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.setContentHuggingPriority(.defaultHigh, for: .horizontal)

            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
    }

    func setupStarFills(_ rating: Double) {
        for (index, button) in buttons.enumerated() {
            if rating >= Double(index + 1) {
                button.setImage(starFillImage, for: .normal)

            } else if rating > Double(index) && rating < Double(index + 1) {
                button.setImage(starLeadingHalfImage, for: .normal)

            } else {
                button.setImage(starEmptyImage, for: .normal)
            }
        }
    }
}
