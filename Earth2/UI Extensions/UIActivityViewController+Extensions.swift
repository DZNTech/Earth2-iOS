//
//  UIActivityViewController+Extensions.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-16.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

extension UIActivityViewController {

    func excludeAllActivityTypes(except activities: [UIActivity.ActivityType]) {
        let allActivities = UIActivity.ActivityType.AllCases

        let newlist = allActivities.filter({ (a) -> Bool in
            for b in activities {
                if a == b { return false }
                else { return true }
            }
            return false
        })

        excludedActivityTypes = newlist
    }

    func excludeAllActivityTypes() {
        excludedActivityTypes = UIActivity.ActivityType.AllCases
    }
}

extension UIActivity.ActivityType {
    static let AllCases: [UIActivity.ActivityType] = [
        .postToFacebook,
        .postToTwitter,
        .postToWeibo,
        .message,
        .mail,
        .print,
        .copyToPasteboard,
        .assignToContact,
        .saveToCameraRoll,
        .addToReadingList,
        .postToFlickr,
        .postToVimeo,
        .postToTencentWeibo,
        .airDrop,
        .openInIBooks,
        .markupAsPDF
    ]
}
