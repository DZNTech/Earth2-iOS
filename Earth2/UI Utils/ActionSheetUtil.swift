//
//  ActionSheetUtil.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-26.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

public typealias ActionSheetCompletionBlock = (UIAlertAction) -> Void

class ActionSheetUtil {

    static func presentActionSheet(withTitle title: String, message: String? = nil, buttonTitle: String? = nil, completion: @escaping ActionSheetCompletionBlock, cancel: ActionSheetCompletionBlock? = nil) {
        guard let topMostVC = UIViewController.topMostViewController() else { return }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.overrideUserInterfaceStyle = .dark
        alert.view.tintColor = Color.white

        alert.addAction(UIAlertAction(title: buttonTitle ?? "Ok", style: .default, handler: completion))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancel))

        topMostVC.present(alert, animated: true)
    }

    static func presentDestructiveActionSheet(withTitle title: String, message: String? = nil, destructiveTitle: String? = nil, completion: ActionSheetCompletionBlock? = nil, cancel: ActionSheetCompletionBlock? = nil) {
        guard let topMostVC = UIViewController.topMostViewController() else { return }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.overrideUserInterfaceStyle = .dark
        alert.view.tintColor = Color.white

        alert.addAction(UIAlertAction(title: destructiveTitle ?? "Ok", style: .destructive, handler: completion))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancel))

        topMostVC.present(alert, animated: true)
    }
}
