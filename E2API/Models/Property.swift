//
//  Property.swift
//  E2API
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation
import ObjectMapper

public class Property: Mappable, Descriptable {

    public var id: ObjectId = ""
    public var landTitle: String = ""
    public var imageUrl: String = ""
    public var tilesCount: Int = 0
    public var purchaseValue: Double = 0
    public var marketValue: Double = 0
    public var location: String = ""
    public var latitude: Double = 0
    public var longitude: Double = 0

    // MARK: - Initialization

    fileprivate static let requiredProperties = ["id"]

    public required convenience init?(map: Map) {
        for requiredProperty in Self.requiredProperties {
            if map.JSON[requiredProperty] == nil { return nil }
        }

        self.init()
        self.mapping(map: map)
    }

    public func mapping(map: Map) {
        id <- map["id"]
        landTitle <- map["land_title"]
        imageUrl <- map["image_url"]
        tilesCount <- map["tiles_count"]
        purchaseValue <- map["purchase_value"]
        marketValue <- map["market_value"]
        location <- map["location"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }

    public static func properties(for JSONObject: [[String : Any]]) -> [Property] {
        var objects = [Property]()

        for dict in JSONObject {
            if let property = Property.init(JSON: dict) {
                objects.append(property)
            }
        }
        return objects
    }
}
