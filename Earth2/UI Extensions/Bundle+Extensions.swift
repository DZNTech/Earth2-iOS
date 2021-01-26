//
//  Bundle+Extensions.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-17.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation

public extension Bundle {

    var bundleName: String {
        return infoDictionary!["CFBundleName"] as! String
    }

    var applicationName: String {
        return infoDictionary!["CFBundleDisplayName"] as! String
    }

    var applicationLongName: String {
        return infoDictionary!["CFBundleDisplayLongName"] as! String
    }

    var releaseVersionNumber: String {
        return infoDictionary!["CFBundleShortVersionString"] as! String
    }

    var buildVersionNumber: String {
        return infoDictionary!["CFBundleVersion"] as! String
    }

    var releaseDescriptionPretty: String {
        return "v\(releaseVersionNumber) (#\(buildVersionNumber))"
    }
}
