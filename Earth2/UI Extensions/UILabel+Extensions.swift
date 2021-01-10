//
//  UILabel+Extensions.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-09.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

extension UILabel {

    func addCharacterSpacing(kernValue: Double = 10) {
        guard let text = text, !text.isEmpty else { return }

        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
        attributedText = attributedString
    }
}
