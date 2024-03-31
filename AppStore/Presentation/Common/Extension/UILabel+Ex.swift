//
//  UILabel+Ex.swift
//  AppStore
//
//  Created by 강호성 on 4/1/24.
//

import UIKit

extension UILabel {
    func setTextWithLineHeight(
        text: String?,
        lineHeight: CGFloat,
        baselineOffset: CGFloat = 2
    ) {
        guard let text = text else { return }

        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        style.alignment = textAlignment

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: baselineOffset
        ]

        let attrString = NSAttributedString(
            string: text,
            attributes: attributes
        )
        self.attributedText = attrString
        self.lineBreakMode = .byTruncatingTail
    }
}
