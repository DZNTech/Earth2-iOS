//
//  Property.swift
//  E2API
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//

import Foundation
import ObjectMapper

public class Property: ImmutableMappable {

    public let id: ObjectId
    public let landTitle: String
    public let imageUrl: String
    public let tilesCount: Int
    public let purchaseValue: Double
    public let marketValue: Double
    public let location: String
    public let latitude: Double
    public let longitude: Double

    // MARK: - Initialization

    required public init(map: Map) throws {
        id = try map.value("id")
        landTitle = try map.value("land_title")
        imageUrl = try map.value("image_url")
        tilesCount = try map.value("tiles_count")
        purchaseValue = try map.value("purchase_value")
        marketValue = try map.value("market_value")
        location = try map.value("location")
        latitude = try map.value("latitude")
        longitude = try map.value("longitude")
    }
}
