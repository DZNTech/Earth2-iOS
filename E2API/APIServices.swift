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

    public var isLocal: Bool = true

    public var isLoggedIn: Bool {
        get { return false }
    }

    public var myUser: User? {
//        get {
//            guard !APIServices.shared.isLocal else {
//                guard let dict = JSONUtil.getLocalJSONObject(for: EndPoint.userLogin) else { return nil }
//                return User.init(JSON: dict)
//            }
//            return nil
//        }
//        set { }
        didSet {
            //
        }
    }

    // MARK: - Initialization

    public init() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }
}
