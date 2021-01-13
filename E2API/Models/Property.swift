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

    public var landTitle: String = ""
    public var imageUrl: String = ""
    public var tilesCount: Int = 0
    public var purchaseValue: Float = 0
    public var marketValue: Float = 0
    public var location: String = ""
    public var country: String = ""
    public var countryCode: String = ""
    public var latitude: Float = 0
    public var longitude: Float = 0

    // MARK: - Initialization

    public required convenience init?(map: Map) {
        self.init()
        self.mapping(map: map)
    }

    public func mapping(map: Map) {
        landTitle <- map["land_title"]
        imageUrl <- map["image_url"]
        tilesCount <- map["tiles_count"]
        purchaseValue <- map["purchase_value"]
        marketValue <- map["market_value"]
        location <- map["location"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]

        country = countryName(from: location)
        countryCode = countryCode(from: location)
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

fileprivate extension Property {

    func countryName(from location: String) -> String {
        guard !location.isEmpty else { return "" }

        let components = location.components(separatedBy: ",")
        return components.last?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    func countryCode(from location: String) -> String {
        let country = countryName(from: location)

        guard !country.isEmpty else { return "" }
        let codes = Locale.isoRegionCodes

        for code in codes {
            let description = Locale.current.localizedString(forRegionCode: code)
            if country == description {
                return code
            }
        }
        return ""
    }
}
