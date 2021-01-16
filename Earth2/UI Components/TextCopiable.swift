//
//  TextCopiable.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-15.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

protocol TextCopiable {
    func isCopiable()
    @discardableResult func shouldHideCopyMenu() -> Bool
}

extension TextCopiable where Self: UIView {

    // MARK: - Public

    func isCopiable() {
        isUserInteractionEnabled = true

        addLongPressGestureRecognizer { [weak self] (gestureRecognizer) in
            self?.showCopyMenu(gestureRecognizer)
        }

        if self is UIButton { }
        else {
            addTapGestureRecognizer { [weak self] (gestureRecognizer) in
                self?.shouldHideCopyMenu()
            }
        }
    }

    func shouldHideCopyMenu() -> Bool {
        let menu = UIMenuController.shared
        let hide = menu.isMenuVisible

        if hide {
            menu.hideMenu(from: self)
        }

        return hide
    }

    // MARK: - Private

    fileprivate func showCopyMenu(_ gestureRecognizer: UIGestureRecognizer) {
        guard gestureRecognizer.state == .began else { return }

        becomeFirstResponder()

        let location = gestureRecognizer.location(in: self)
        let rect = CGRect(origin: location, size: .zero)

        let menu = UIMenuController.shared
        menu.showMenu(from: self, rect: rect)
    }
}
