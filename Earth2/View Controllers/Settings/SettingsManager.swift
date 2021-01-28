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
        get { return getDateSetting(for: .lastUpdateDate, defaultValue: nil) }
        set { setDateSetting(newValue, for: .lastUpdateDate) }
    }

    static var saveDataEnabled: Bool {
        get { return getBoolSetting(for: .saveData) }
        set { setBoolSetting(newValue, for: .saveData) }
    }

    static var saveCredentialsEnabled: Bool {
        get { return getBoolSetting(for: .saveCredentials) }
        set { setBoolSetting(newValue, for: .saveCredentials) }
    }
}

fileprivate extension SettingsManager {

    static func getDateSetting(for key: SettingsKey, defaultValue: Date? = Date()) -> Date? {
        guard let timestamp = UserDefaults.standard.string(forKey: key.rawValue) else { return defaultValue }

        let formatter = DateUtil.standardFormatter
        return formatter.date(from: timestamp)
    }

    static func setDateSetting(_ date: Date?, for key: SettingsKey) {
        if let date = date {
            let formatter = DateUtil.standardFormatter
            let timestamp = formatter.string(from: date)
            UserDefaults.standard.set(timestamp, forKey: key.rawValue)
        } else {
            UserDefaults.standard.set(nil, forKey: key.rawValue)
        }
    }

    static func getBoolSetting(for key: SettingsKey, defaultValue: Bool = true) -> Bool {
        if UserDefaults.standard.object(forKey: key.rawValue) == nil {
            setBoolSetting(defaultValue, for: key) // default value
        }

        return UserDefaults.standard.bool(forKey: key.rawValue)
    }

    static func setBoolSetting(_ value: Bool, for key: SettingsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
}

fileprivate enum SettingsKey: String {
    case lastUpdateDate = "com.dzntech.e2.settings.lastUpdateDate"
    case saveData = "com.dzntech.e2.settings.saveData"
    case saveCredentials = "com.dzntech.e2.settings.saveCredentials"
}
