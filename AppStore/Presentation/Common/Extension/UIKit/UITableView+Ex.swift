//
//  UITableView+Ex.swift
//  AppStore
//
//  Created by 강호성 on 4/2/24.
//

import UIKit

extension UITableView {
    func setEmptyBackgroundTableView(text: String) {
        self.backgroundView = EmptyView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: self.bounds.width,
                height: self.bounds.height
            ),
            text: text
        )

        self.isScrollEnabled = true
        self.separatorStyle = .none
    }

    func removeBackgroundTableView() {
        self.isScrollEnabled = true
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}
