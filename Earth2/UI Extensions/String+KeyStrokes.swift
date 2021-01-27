//
//  String+KeyStrokes.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-27.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation

extension String {

    var isBackSpace: Bool {
        let char = string.cString(using: String.Encoding.utf8)!
        let backSpace = strcmp(char, "\\b")
        return backSpace == -92
    }

    var isWhiteSpace: Bool {
        let whitespaceSet = NSCharacterSet.whitespaces
        return rangeOfCharacter(from: whitespaceSet) != nil
    }
}
