//
//  E2APIConstants.swift
//  E2API
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

public typealias ObjectId = String

public let APIBaseUrl: String = "https://www.earth2api.com/"
public let APIKey: String = "OOA8TueUjeFwmVVpjb0`;-]Q7E{"

public let StandardPageSize: Int = 50

enum EndPoint {
    static let userLogin = "user/login"
    static let propertyList = "user/properties"
}

enum ParameterKey {
    static let apiKey = "apiKey"
    static let contentType = "Content-type"
    static let httpStatus = "httpStatus"
    static let errors = "errors"
    static let status = "status"
    static let data = "data"

    static let currentPage = "currentPage"
    static let pageSize = "pageSize"
    static let statusDescription = "statusDescription"

    static let id = "id"
    static let email = "email"
    static let password = "password"
    static let username = "username"
    static let userId = "user_id"
}
