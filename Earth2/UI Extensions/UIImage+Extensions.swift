//
//  UIImage+Extensions.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-28.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

extension UIImage {

    static func image(with color: UIColor? = nil, size: CGSize) -> UIImage? {
        defer {  UIGraphicsEndImageContext() }

        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        let rect = CGRect(origin: .zero, size: size)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 0)
        path.addClip()

        if let color = color {
            color.setFill()
            path.fill()
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
