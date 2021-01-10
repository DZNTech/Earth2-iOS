//
//  UILabel+Extensions.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-09.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

extension UILabel {

    func addCharacterSpacing(kernValue: Double = 15) {
    if let labelText = text, labelText.count > 0 {
        let attributedString = NSMutableAttributedString(string: labelText)
        if #available(iOS 14.0, *) {
            attributedString.addAttribute(.tracking, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
        } else {
            attributedString.addAttribute(.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
        }
        attributedText = attributedString
        }
    }
}
