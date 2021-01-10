//
//  UIView+Extensions.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-09.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

extension UIView {

    func addGlow(with color: UIColor, radius: CGFloat = 5, opacity: Float = 1) {
        layer.shadowOffset = .zero
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }

    func addBorder(with color: UIColor, radius: CGFloat = 5) {
        layer.borderColor = color.cgColor
        layer.borderWidth = radius
    }

    func setY(_ y: CGFloat) {
        var rect = frame
        rect.origin.y = y
        frame = rect
    }

    func setX(_ x: CGFloat) {
        var rect = frame
        rect.origin.x = x
        frame = rect
    }

    func setWidth(_ width: CGFloat) {
        var rect = frame
        rect.size.width = width
        frame = rect
    }

    func setHeight(_ height: CGFloat) {
        var rect = frame
        rect.size.height = height
        frame = rect
    }
}
