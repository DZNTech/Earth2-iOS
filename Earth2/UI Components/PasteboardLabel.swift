//
//  PasteboardLabel.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-15.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

class PasteboardLabel: UILabel, TextCopiable {

    // MARK: - Initializatiom

    override init(frame: CGRect) {
        super.init(frame: frame)
        isCopiable()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Pasteboard Management

    override public var canBecomeFirstResponder: Bool {
        get { return true }
    }

    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
        UIMenuController.shared.hideMenu()
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return (action == #selector(copy(_:)))
    }
}
