//
//  StringConstants.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-14.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation
import E2API

enum StringConstants {
    static let EDSymbol = "E$"
    static let USDSymbol = "US$"

    static let nonaffiliateDisc = "Not affiliated or endorsed by E2"
    static let nonaffiliateDiscLong = "Not affiliated, associated, authorized, endorsed by, or in any way officially connected with Earth 2"

    static let dataSavingDisc = "For a better user experience, your E2 data is safely encrypted and ONLY stored locally. This helps speeding up the app launch, displaying outdated information while loading new data"
    static let credentialSavingDisc = "Your E2 credentials are safely encrypted and ONLY stored locally using Apple's Keychain technology in order to automatically login to \(Web.displayUrl(.home)) when launching this app. This helps to avoid manually typing your credentials each time"
    static let logOutDisc = "When logging out, the data stored on this device will be deleted and the app will act like a new install"

    static let copyright = "Copyright © 2020 DZN Technologies Inc."
}
