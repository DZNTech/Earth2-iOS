//
//  APIConstants.swift
//  E2API
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

public typealias ObjectId = String

public let APIBaseUrl: String = "https://earth2api.herokuapp.com/"
public let StandardPageSize: Int = 50

public enum EndPoint {
    static let userLogin = "users/login/"
    static let propertyList = "users/properties/"
}

public enum ParameterKey {
    static let apiKey = "Api-Key"
    static let contentType = "Content-type"
    static let authorization = "Authorization"
    static let httpStatus = "httpStatus"
    static let error = "error"
    static let detail = "detail"
    static let status = "status"
    static let data = "data"
    static let sessionId = "sessionId"

    static let currentPage = "currentPage"
    static let pageSize = "pageSize"
    static let statusDescription = "statusDescription"

    static let id = "id"
    static let email = "email"
    static let password = "password"
    static let username = "username"
    static let userId = "user_id"
}
