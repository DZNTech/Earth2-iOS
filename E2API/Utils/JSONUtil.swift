//
//  JSONUtil.swift
//  E2API
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

public class JSONUtil {

    public static func getLocalJSON(for endpoint: String) -> JSON? {
        let bundle = Bundle(for: JSONUtil.self)
        guard let path = bundle.path(forResource: endpoint.fileName(), ofType: "json") else { return nil }
        guard let jsonString = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) else { return nil }
        return JSON(parseJSON: jsonString)
    }

    public static func getLocalDictObject(for endpoint: String) -> [String : Any]? {
        guard let json = getLocalJSON(for: endpoint) else { return nil }
        return json.dictionaryObject?[ParameterKey.data] as? [String : Any]
    }

    public static func getLocalDictObject(from json: JSON) -> [String : Any]? {
        return json.dictionaryObject?[ParameterKey.data] as? [String : Any]
    }

    public static func getLocalDictObjects(for endpoint: String) -> [[String : Any]]? {
        guard let json = getLocalJSON(for: endpoint) else { return nil }
        return json.dictionaryObject?[ParameterKey.data] as? [[String : Any]]
    }

    public static func getLocalDictObjects(from json: JSON) -> [[String : Any]]? {
        return json.dictionaryObject?[ParameterKey.data] as? [[String : Any]]
    }
}

fileprivate extension String {

    func fileName() -> String {
        let name = String(self.dropLast())
        return name.replacingOccurrences(of: "/", with: ".")
    }
}
