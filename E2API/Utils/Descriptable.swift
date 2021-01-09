//
//  Descriptable.swift
//  E2API
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation

public protocol Descriptable {
    var attributesDescription: NSString { get }
}

extension Descriptable {

    public var attributesDescription: NSString {

        let mirror = Mirror(reflecting: self)
        var output: [String] = ["{"]

        for (_, attr) in mirror.children.enumerated() {
            if let property_name = attr.label {
                output.append("    - \(property_name) = \(attr.value)")
            }
        }

        output.append("}")

        return NSString(string: output.joined(separator: "\n"))
    }
}
