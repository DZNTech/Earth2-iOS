//
//  AuthApi.swift
//  E2API
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON

// MARK: - Interface
public protocol AuthApiInterface {

    /**
     Simple account authentication using email/password.

     - parameter email: Account email.
     - parameter password: Account password.
     - parameter completion: The closure to be called upon completion
     */
    func login(_ email: String, password: String, _ completion: @escaping ObjectCompletionBlock<User>)
}

public class AuthApi: AuthApiInterface {

    public init() {}
    fileprivate let repositoryAdapter = RepositoryAdapter()

    public func login(_ email: String, password: String, _ completion: @escaping ObjectCompletionBlock<User>) {

        let endpoint = EndPoint.userLogin
        let parameters: Parameters = [
            ParameterKey.email: email,
            ParameterKey.password: password
        ]

        repositoryAdapter.getObject(endpoint, parameters: parameters, type: User.self) { (user, error) in
            completion(user, error)
        }
    }
}
