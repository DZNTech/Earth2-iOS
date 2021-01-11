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

        // local use
        guard !E2APIServices.shared.isLocal else {
            guard let dict = JSONUtil.getLocalJSONObject(for: endpoint) else { return }
            completion(User.init(JSON: dict), nil)
            return
        }

        let parameters: Parameters = [
            ParameterKey.email: email,
            ParameterKey.password: password
        ]

        repositoryAdapter.networkAdapter.httpRequest(endpoint, method: .post, parameters: parameters) { (request) in
            print("Starting request \(String(describing: request.request?.url)) with parameters \(String(describing: parameters))")
            request.responseObject(keyPath: ParameterKey.data, completionHandler: { (response: DataResponse<User>) in
                print("Ended request with code \(String(describing: response.response?.statusCode))")

                if let code = response.response?.statusCode, code == 401 {
                    print("Detected 401. Should log out User!")
                }

                switch response.result {
                case .success(let object):
                    guard let data = response.data else { return }
                    let json = JSON(data)

                    if let errors = ErrorUtil.errors(fromJSON: json) {
                        completion(nil, errors.first)
                    } else {
                        E2APIServices.shared.myUser = object
                        E2APISessionManager.handleSessionJSON(json)
                        E2APISessionManager.setSessionEmail(email)
                        E2APISessionManager.setSessionPassword(password)

                        completion(object, nil)
                    }
                case .failure:
                    let error = ErrorUtil.parseError(response)
                    print("network error \(error.debugDescription)")
                    completion(nil, error)
                }
            })
        }
    }
}
