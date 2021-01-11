//
//  E2APICredentials.swift
//  E2API
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-10.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation
import Valet

public class APICredential {
    public let apiKey: String
    public let email: String?
    public let password: String?

    init() {
        apiKey = "oq9CUUTI.MJOrA7W4kZbnBuAUySLQ6Y7Fab5ZF6CN"

        // Development tool for auto-completing the login screen
        #if DEBUG
            let bundle = Bundle(for: APICredential.self)

            // TODO: Throw and print error
            if let path = bundle.path(forResource: "Credentials", ofType: "plist"),
                let dict = NSDictionary(contentsOfFile: path) {
                email = dict["EMAIL"] as? String
                password = dict["PASSWORD"] as? String
            } else {
                email = nil
                password = nil
            }
        #else
            email = nil
            password = nil
        #endif
    }
}
