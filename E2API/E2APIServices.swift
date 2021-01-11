//
//  E2APIServices.swift
//  E2API
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation
import AlamofireNetworkActivityIndicator

public class E2APIServices {

    public static let shared = E2APIServices()
    public let credential = APICredential()
    public var isLocal: Bool = true

    public var isLoggedIn: Bool {
        get { return false }
    }

    // MARK: - Initialization

    public init() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }
}
