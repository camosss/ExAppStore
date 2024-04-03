//
//  UIImageView+Ex.swift
//  AppStore
//
//  Created by 강호성 on 4/1/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(
        with urlString: String,
        completion: ((_ imageSize: CGSize?) -> Void)? = nil
    ) {
        guard let url = URL(string: urlString) else {
            completion?(nil)
            return
        }

        self.kf.setImage(with: url, options: [.transition(.fade(1))]) { result in
            switch result {
            case .success(let value):
                let imageSize = value.image.size
                completion?(imageSize)

            case .failure(_):
                completion?(nil)
            }
        }
    }
}
