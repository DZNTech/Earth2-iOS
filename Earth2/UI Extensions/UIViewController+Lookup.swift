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
        guard let window = keyWindow() else { return nil }
        return window.rootViewController
    }

    static func keyWindow() -> UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return nil }
               return window
    }

    static func topLayoutOffset() -> CGFloat {
        guard let rootVC = rootViewController() else { return 0}
        if #available(iOS 11.0, *) { return rootVC.view.safeAreaInsets.top } else { return rootVC.topLayoutGuide.length }
    }

}
