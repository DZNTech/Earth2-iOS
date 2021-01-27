//
//  UIViewController+Lookup.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-12.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

extension UIViewController {

    static func topMostViewController() -> UIViewController? {
        guard let rootViewController = rootViewController() else {
            return nil
        }

        var topController = rootViewController

        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }

        return topController
    }

    static func rootViewController() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow else { return nil }
        return window.rootViewController
    }

    static func statusBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }

}
