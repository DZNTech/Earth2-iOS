//
//  CustomButton.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-15.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    var hitTestEdgeInsets: UIEdgeInsets = .zero

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {

        if hitTestEdgeInsets == .zero {
            return super.point(inside: point, with: event)
        } else {
            let hitFrame = bounds.inset(by: hitTestEdgeInsets)
            return hitFrame.contains(point)
        }
    }
}

class CustomStackView: UIStackView {

    var hitTestEdgeInsets: UIEdgeInsets = .zero

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {

        if hitTestEdgeInsets == .zero {
            return super.point(inside: point, with: event)
        } else {
            let hitFrame = bounds.inset(by: hitTestEdgeInsets)
            return hitFrame.contains(point)
        }
    }
}

