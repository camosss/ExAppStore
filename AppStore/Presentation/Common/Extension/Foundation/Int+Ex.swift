//
//  Int+Ex.swift
//  AppStore
//
//  Created by 강호성 on 4/1/24.
//

import Foundation

extension Int {
    var formattedString: String {
        var formattedValue = ""

        if self >= 10000 {
            let tenThousands = Int(self / 10000)
            let remainingThousands = Int((self % 10000) / 1000)
            if remainingThousands > 0 {
                formattedValue = "\(tenThousands).\(remainingThousands)만"
            } else {
                formattedValue = "\(tenThousands)만"
            }

        } else if self >= 1000 {
            let thousands = Int(self / 1000)
            let remainingHundreds = Int((self % 1000) / 100)
            if remainingHundreds > 0 {
                formattedValue = "\(thousands).\(remainingHundreds)천"
            } else {
                formattedValue = "\(thousands)천"
            }

        } else {
            formattedValue = "\(self)"
        }

        return formattedValue
    }
}
