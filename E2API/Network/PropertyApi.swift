//
//  PropertyApi.swift
//  E2API
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation

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
        listProperties(forUser: "", completion)
    }

    public func listProperties(forUser userId: ObjectId, currentPage: Int = 1, pageSize: Int = StandardPageSize, _ completion: @escaping ObjectCompletionBlock<[Property]>) {

        let endpoint = EndPoint.propertyList

        guard !APIServices.shared.isLocal else {
            guard let dict = JSONUtil.getLocalJSONObjects(for: endpoint) else { return }
            completion(Property.properties(for: dict), nil)
            return
        }

        let parameters = [ParameterKey.userId: userId]

        repositoryAdapter.getObjects(endpoint, parameters: parameters, currentPage: currentPage, pageSize: pageSize, type: Property.self) { (properties, error) in
            completion(properties, error)
        }
    }
}
