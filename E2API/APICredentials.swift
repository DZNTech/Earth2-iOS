//
//  APICredentials.swift
//  E2API
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-10.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation

public class APICredentials {
    public let email: String?
    public let password: String?

    public let e2APIKey: String
    public let mapboxAPIKey: String

    init() {
        e2APIKey = "oq9CUUTI.MJOrA7W4kZbnBuAUySLQ6Y7Fab5ZF6CN"
        mapboxAPIKey = "pk.eyJ1IjoiZHpuIiwiYSI6ImNranN3dnVpNDA0eXozM3FzcjlxMzIweXkifQ.bFoLTSgzwGTaoVfmUQ5XYw"

        // Development tool for auto-completing the login screen
        #if DEBUG
            let bundle = Bundle(for: APICredentials.self)

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
