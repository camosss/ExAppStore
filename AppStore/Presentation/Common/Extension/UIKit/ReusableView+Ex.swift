//
//  ReusableView+Ex.swift
//  AppStore
//
//  Created by 강호성 on 3/31/24.
//

import UIKit

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension UITableViewHeaderFooterView: ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
