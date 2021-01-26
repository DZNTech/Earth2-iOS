//
//  WebConstants.swift
//  E2API
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation
import CoreGraphics

public enum WebConstant: String {
    case home = "https://earth2.io/"
    case login = "https://app.earth2.io/login/auth0"

    case map = "https://app.earth2.io/#thegrid/"
    case about = "https://earth2.io/about"
    case faq = "https://earth2.io/faq"
}

public class Web {

    // Converts an existing MapBox URL for custom sizing and custom API key
    public static func convertMapBoxUrl(from url: String, with size: CGSize) -> String? {
        guard let range = url.range(of: "/", options: .backwards) else { return nil }
        var newUrl = String(url[...range.lowerBound])

        newUrl += "\(Int(size.width))x\(Int(size.height))"
        newUrl += "?access_token=\(APIServices.shared.credential.mapboxAPIKey)"

        return newUrl
    }

    public static func displayUrl(_ webConstant: WebConstant) -> String {
        let url = URL(string: webConstant.rawValue)
        return url?.host ?? webConstant.rawValue
    }
}
