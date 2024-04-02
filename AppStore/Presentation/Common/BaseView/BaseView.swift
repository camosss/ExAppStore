//
//  BaseView.swift
//  AppStore
//
//  Created by 강호성 on 4/2/24.
//

import UIKit.UIView

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
        setConfigurations()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setViews() { }
    func setConstraints() { }
    func setConfigurations() {
        backgroundColor = .white
    }
}
