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


//    public static func getUrl(for constant: MGPWebConstant, value: String? = nil) -> String {
//
//        var baseUrl = constant.rawValue
//        if APIServices.shared.settings.isDev {
//            baseUrl = constant.rawValue.replacingOccurrences(of: "www", with: "test")
//        }
//
//        if let value = value {
//            return "\(baseUrl)=\(value.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil))"
//        } else {
//            return baseUrl
//        }
//    }
//
//    public static func getPrefilledFeedbackFormUrl() -> String? {
//        guard var urlComponents = URLComponents(string: MGPWebConstant.feedbackPrefilledForm.rawValue) else { return nil }
//        var queryItems = [URLQueryItem]()
//
//        guard let user = APIServices.shared.myUser else { return nil }
//
//        let fullname = "\(user.firstName) \(user.lastName)"
//        let username = user.userName
//
//        queryItems.append(URLQueryItem(name: "entry.3082215", value: fullname))
//
//        if let email = APISessionManager.getSessionEmail() {
//            queryItems.append(URLQueryItem(name: "entry.1185283391", value: email))
//        }
//
//        queryItems.append(URLQueryItem(name: "entry.1807575595", value: username))
//
//        urlComponents.queryItems = queryItems
//        return urlComponents.url?.absoluteString
//    }
//
//    public static func getPrefilledUTT1LapPrefilledFormUrl(_ track: Track) -> String? {
//        return getPrefilledUTTFormUrl(MGPWebConstant.utt1LapPrefilledForm.rawValue, track: track)
//    }
//
//    public static func getPrefilledUTT3LapPrefilledFormUrl(_ track: Track) -> String? {
//        return getPrefilledUTTFormUrl(MGPWebConstant.utt3LapPrefilledForm.rawValue, track: track)
//    }
//
//    public static func getPrefilledUTTFormUrl(_ formUrl: String, track: Track) -> String? {
//        guard var urlComponents = URLComponents(string: formUrl) else { return nil }
//        var queryItems = [URLQueryItem]()
//
//        guard let user = APIServices.shared.myUser, let chapter = APIServices.shared.myChapter else { return nil }
//
//        let fullname = "\(user.firstName) \(user.lastName)"
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let dateString = formatter.string(from: Date())
//
//        // Append the new query item in the existing query items array
//        queryItems.append(URLQueryItem(name: "entry.348091437", value: "Yes"))          // needs to accept form first
//        queryItems.append(URLQueryItem(name: "entry.1800936478", value: fullname))
//
//        queryItems.append(URLQueryItem(name: "entry.1639711361", value: track.title))   // track name
//        queryItems.append(URLQueryItem(name: "entry.1305427815", value: dateString))    // date of event (today)
//
//        queryItems.append(URLQueryItem(name: "entry.111335806", value: chapter.name))
//        queryItems.append(URLQueryItem(name: "entry.167275231", value: chapter.phone))
//
//        if let email = APISessionManager.getSessionEmail() {
//            queryItems.append(URLQueryItem(name: "entry.1231628105", value: email))
//        }
//
//        urlComponents.queryItems = queryItems
//        return urlComponents.url?.absoluteString
//    }
}
