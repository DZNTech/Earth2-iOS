//
//  Settings.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-18.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation

class SettingsManager {

    static func shouldSaveCredentials() -> Bool {
        if UserDefaults.standard.object(forKey: saveCredentialsKey) == nil {
            setShouldSaveCredentials(true) // default value
        }

        return UserDefaults.standard.bool(forKey: saveCredentialsKey)
    }

    static func setShouldSaveCredentials(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: saveCredentialsKey)
    }

    fileprivate static let saveCredentialsKey = "com.dzntech.e2.settings.saveCredentials"
}
