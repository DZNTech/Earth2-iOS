//
//  FlagEmojiGenerator.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-12.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

class FlagEmojiGenerator: NSObject {

    static func flag(country: String?) -> String {
        guard let country = country else { return "" }

        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }

        return String(s)
    }
}
