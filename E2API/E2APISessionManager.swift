//
//  E2APISessionManager.swift
//  E2API
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Valet

class E2APISessionManager {

    // MARK: - Session

    public static func hasValidSession() -> Bool {
        return getSessionId() != nil
    }

    public static func getSessionId() -> String? {
        return valet.string(forKey: sessionIdKey)
    }

    public static func invalidateSession() {
        setSessionId(nil)
    }

    static func handleSessionJSON(_ json: JSON) {
        guard let sessionId = json[ParameterKey.data][ParameterKey.id].string else { return }
        setSessionId(sessionId)
    }

    // MARK: - Email

    public static func getSessionEmail() -> String? {
        return valet.string(forKey: sessionEmailKey)
    }

    static func setSessionEmail(_ email: String) {
        valet.set(string: email, forKey: sessionEmailKey)
    }

    // MARK: - Password

    static func setSessionPassword(_ pwd: String) {
        valet.set(string: pwd, forKey: sessionPasswordKey)
    }

    public static func getSessionPassword() -> String? {
        return valet.string(forKey: sessionPasswordKey)
    }

    // MARK: - Private

    fileprivate static func setSessionId(_ sessionId: String?) {
        if let sessionId = sessionId {
            valet.set(string: sessionId, forKey: sessionIdKey)
        } else {
            valet.removeObject(forKey: sessionIdKey)
            valet.removeObject(forKey: sessionEmailKey)
            valet.removeObject(forKey: sessionPasswordKey)
        }
    }

    fileprivate static let valet = Valet.valet(with: Identifier(nonEmpty: "e2")!, accessibility: .whenUnlocked)

    fileprivate static let sessionIdKey = "com.dzntech.e2.session.id"
    fileprivate static let sessionEmailKey = "com.dzntech.e2.session.email"
    fileprivate static let sessionPasswordKey = "com.dzntech.e2.session.password"
}
