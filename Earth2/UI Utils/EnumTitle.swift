//
//  EnumTitle.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-17.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation

public protocol EnumTitle: CaseIterable {
    var title: String { get }
    init?(title: String)
}

extension EnumTitle {
    public init?(title: String) {
        for `case` in Self.allCases {
            if `case`.title == title {
                self = `case`
                return
            }
        }
        return nil
    }
}
