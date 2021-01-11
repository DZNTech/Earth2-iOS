//
//  UIActivityIndicatorView+Extensions.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-11.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {

    func animate(_ start: Bool = true) {
        if start {
            startAnimating()
        } else {
            stopAnimating()
        }
    }
}
