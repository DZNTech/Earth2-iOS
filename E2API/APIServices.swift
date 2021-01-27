//
//  APIServices.swift
//  E2API
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation
import AlamofireNetworkActivityIndicator

public class APIServices {

    public static let shared = APIServices()
    public let credential = APICredentials()

    public var isLocal: Bool = false

    public var myUser: User?

    // MARK: - Initialization

    public init() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }

    // MARK: - Invalidation

    public func invalidate() {
        myUser = nil
    }
}
