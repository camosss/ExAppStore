//
//  UIImageView+Ex.swift
//  AppStore
//
//  Created by 강호성 on 4/1/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        self.kf.setImage(with: url, options: [.transition(.fade(1))])
    }
}
