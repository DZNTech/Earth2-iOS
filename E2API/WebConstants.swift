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

    case feebackPrefill = "https://docs.google.com/forms/d/e/1FAIpQLSdVo_t4EDcBMENDKeYb2cecOiUrvzRxrBUdHYoOUpWM6_OOaA/viewform"
    case feebackShort = "forms.gle/nkn4YFjukjXy8DKz9"

    case testFlight = "testflight.apple.com/join/q24YtYT6"
    case sourceCode = "github.com/DZNTech/Earth2-iOS"
    case linkedIn = "linkedin.com/in/ignacioromeroz/"
}

public class Web {

    // Converts an existing MapBox URL for custom sizing and custom API key
    // Unless these are self-hosted images from AWS
    public static func convertUrl(from url: String, with size: CGSize) -> String? {
        guard url.range(of: "amazonaws", options: .caseInsensitive) == nil else { return url }
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

    public static func getPrefilledFeedbackFormUrl() -> String? {
        guard var urlComponents = URLComponents(string: WebConstant.feebackPrefill.rawValue) else { return nil }
        var queryItems = [URLQueryItem]()

        if let user = APIServices.shared.myUser {
            queryItems.append(URLQueryItem(name: "entry.1807575595", value: user.username))
        }

        if let email = APIServices.shared.credential.email {
            queryItems.append(URLQueryItem(name: "entry.1185283391", value: email))
        }

        urlComponents.queryItems = queryItems
        return urlComponents.url?.absoluteString
    }
}
