//
//  BaseTableViewCell.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import UIKit

class BaseTableViewCell<T>: UITableViewCell {

    var model: T? {
        didSet {
            if let model = model {
                bind(model)
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
        setConstraints()
        setConfigurations()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setViews() {}
    func setConstraints() {}
    func setConfigurations() {
        selectionStyle = .none
    }

    func bind(_ model: T?) {}
}
