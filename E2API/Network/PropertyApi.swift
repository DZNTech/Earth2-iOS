//
//  PropertyApi.swift
//  E2API
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Interface
public protocol PropertyApiInterface {

    /**
     */
    func listMyProperties(currentPage: Int, pageSize: Int, _ completion: @escaping ObjectCompletionBlock<[Property]>)

    /**
     */
    func listProperties(forUser userId: ObjectId, currentPage: Int, pageSize: Int, _ completion: @escaping ObjectCompletionBlock<[Property]>)
}

public class PropertyApi: PropertyApiInterface {

    public init() {}
    fileprivate let repositoryAdapter = RepositoryAdapter()

    public func listMyProperties(currentPage: Int = 1, pageSize: Int = StandardPageSize, _ completion: @escaping ObjectCompletionBlock<[Property]>) {
        guard let user = APIServices.shared.myUser else { return }

        listProperties(forUser: user.id, completion)
    }

    public func listProperties(forUser userId: ObjectId, currentPage: Int = 1, pageSize: Int = StandardPageSize, _ completion: @escaping ObjectCompletionBlock<[Property]>) {

        let endpoint = EndPoint.propertyList

        guard !APIServices.shared.isLocal else {
            guard let dict = JSONUtil.getLocalDictObjects(for: endpoint) else { return }
            completion(Property.properties(for: dict), nil)
            return
        }

        let parameters: Parameters = [
            ParameterKey.userId: userId,
            ParameterKey.currentPage: currentPage,
            ParameterKey.pageSize: pageSize
        ]

        repositoryAdapter.getObjects(endpoint, parameters: parameters, type: Property.self) { (properties, error) in
            completion(properties, error)
        }
    }
}
