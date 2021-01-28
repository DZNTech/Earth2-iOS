//
//  Settings.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-18.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation

class SettingsManager {

    static var lastUpdate: Date? {
        get { return lastUpdateDate() }
        set { setLastUpdateDate(newValue) }
    }

    static var staySignedIn: Bool {
        get { return shouldSaveCredentials() }
        set { setShouldSaveCredentials(newValue) }
    }
}

fileprivate extension SettingsManager {

    static func lastUpdateDate() -> Date? {
        guard let timestamp = UserDefaults.standard.string(forKey: lastUpdateDateKey) else { return nil }

        let formatter = DateUtil.standardFormatter
        return formatter.date(from: timestamp)
    }

    static func setLastUpdateDate(_ date: Date?) {
        if let date = date {
            let formatter = DateUtil.standardFormatter
            let timestamp = formatter.string(from: date)
            UserDefaults.standard.set(timestamp, forKey: lastUpdateDateKey)
        } else {
            UserDefaults.standard.set(nil, forKey: lastUpdateDateKey)
        }
    }

    static func shouldSaveCredentials() -> Bool {
        if UserDefaults.standard.object(forKey: saveCredentialsKey) == nil {
            setShouldSaveCredentials(true) // default value
        }

        return UserDefaults.standard.bool(forKey: saveCredentialsKey)
    }

    static func setShouldSaveCredentials(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: saveCredentialsKey)
    }

    static let lastUpdateDateKey = "com.dzntech.e2.settings.lastUpdateDate"
    static let saveCredentialsKey = "com.dzntech.e2.settings.saveCredentials"
}

