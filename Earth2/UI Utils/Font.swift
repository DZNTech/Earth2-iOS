//
//  Font.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-12.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

class Font {

    static func font(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        switch weight {
        case .ultraLight:
            return UIFont(name: "AvenirNext-UltraLight", size: fontSize)!
        case .light:
            return UIFont(name: "AvenirNext-Italic", size: fontSize)!
        case .regular:
            return UIFont(name: "AvenirNext-Regular", size: fontSize)!
        case .medium:
            return UIFont(name: "AvenirNext-Medium", size: fontSize)!
        case .semibold:
            return UIFont(name: "AvenirNext-DemiBold", size: fontSize)!
        case .bold:
            return UIFont(name: "AvenirNext-Bold", size: fontSize)!
        default:
            return UIFont(name: "AvenirNext-Regular", size: fontSize)!
        }
    }

}
