//
//  UIImage+Ex.swift
//  AppStore
//
//  Created by 강호성 on 4/2/24.
//

import UIKit.UIImage

extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
