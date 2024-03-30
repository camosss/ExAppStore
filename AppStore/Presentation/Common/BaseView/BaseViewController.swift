//
//  BaseViewController.swift
//  AppStore
//
//  Created by 강호성 on 3/30/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigurations()
        setViews()
        setConstraints()
    }

    func setViews() { }
    func setConstraints() { }

    func setConfigurations() {
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = ""
    }
}
