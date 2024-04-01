//
//  DetailAppInfoDescriptionTableViewCell.swift
//  AppStore
//
//  Created by 강호성 on 4/1/24.
//

import UIKit
import RxSwift

protocol DetailAppInfoDescriptionTableViewCellDelegate: AnyObject {
    func moreButtonDidTap()
}

final class DetailAppInfoDescriptionTableViewCell: BaseTableViewCell<AppInfo> {

    // MARK: - Properties

    weak var delegate: DetailAppInfoDescriptionTableViewCellDelegate?
    private var disposeBag = DisposeBag()

    private let containerView = UIView()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("더 보기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()

    // MARK: - Helpers

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func setViews() {
        super.setViews()
        contentView.addSubview(containerView)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(moreButton)
        contentView.addSubview(dividerView)
    }

    override func setConstraints() {
        super.setConstraints()
        containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(24)
        }
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.trailing.equalToSuperview().inset(18)
            make.bottom.equalToSuperview()
        }
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(16)
            make.leading.equalTo(24)
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    override func setConfigurations() {
        super.setConfigurations()
        bindCellEvent()
    }

    override func bind(_ model: AppInfo?) {
        super.bind(model)

        if let description = model?.description, 
            let releaseNotes = model?.releaseNotes {

            descriptionLabel.setTextWithLineHeight(
                text: "\(description)\n\(releaseNotes)",
                lineHeight: 20
            )
        }
    }

    private func bindCellEvent() {
        moreButton.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let self = self else { return }

                self.descriptionLabel.numberOfLines = 0
                self.moreButton.isHidden = true

                self.delegate?.moreButtonDidTap()
            })
            .disposed(by: disposeBag)
    }
}
