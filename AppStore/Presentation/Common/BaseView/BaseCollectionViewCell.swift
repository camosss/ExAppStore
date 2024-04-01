//
//  BaseCollectionViewCell.swift
//  AppStore
//
//  Created by 강호성 on 4/1/24.
//

import UIKit.UICollectionViewCell

class BaseCollectionViewCell<T>: UICollectionViewCell {

    var model: T? {
        didSet {
            if let model = model {
                bind(model)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
        setConfigurations()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setViews() {}
    func setConstraints() {}
    func setConfigurations() {}

    func bind(_ model: T?) {}
}

