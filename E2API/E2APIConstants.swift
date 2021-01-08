//
//  E2APIConstants.swift
//  E2API
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//

import UIKit

public typealias ObjectId = String

public let StandardPageSize: Int = 50

enum EndPoint {
    static let userLogin = "user/login"
    static let userProperties = "user/properties"
}

enum ParameterKey {
    static let apiKey = "apiKey"
}
