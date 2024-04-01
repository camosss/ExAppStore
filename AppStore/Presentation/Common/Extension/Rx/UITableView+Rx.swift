//
//  UITableView+Rx.swift
//  AppStore
//
//  Created by 강호성 on 4/2/24.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UITableView {
    func isEmptyTableView(text: String) -> Binder<Bool> {
        return Binder(base) { tableView, isEmpty in
            if isEmpty {
                tableView.setEmptyBackgroundTableView(text: text)
            } else {
                tableView.removeBackgroundTableView()
            }
        }
    }
}
