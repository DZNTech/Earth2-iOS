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
    public var profitValue: Float = 0
    public var profitPct: Float = 0

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
        tilesCount = tileCount(from: map.JSON["tiles_count"])

        location <- map["location"]
        country = countryName(from: location)
        countryCode = countryCode(from: location)
        latitude <- map["latitude"]
        longitude <- map["longitude"]

        purchaseValue = float(from: map.JSON["purchase_value"])
        marketValue = float(from: map.JSON["market_value"])
        profitValue = marketValue - purchaseValue
        profitPct = marketValue*100/purchaseValue
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

//"latitude": "-64.72312",
//"longitude": "-4.179247",
//"location": "Tefé, Amazonas, Brazil",
//"image_url": "https://api.mapbox.com/styles/v1/mapbox/satellite-v9/static/-64.72312, -4.179247}, 16.0, 0.0, 0.0/520x400?access_token=pk.eyJ1IjoiZXYyIiwiYSI6ImNraHB6cXVtcjA0emkycm84cTBxdnBscGkifQ.VX6qEmMYgvhYBCZJKzJ2cA",
//"tiles_count": "3 tiles",
//"land_title": "Tefé",
//"purchase_value": "1.70",
//"market_value": "5.09"

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

    func tileCount(from object: Any?) -> Int {
        guard let string = object as? String, !string.isEmpty else { return 0 }

        let components = string.components(separatedBy: " ")

        if let number = components.first, let value = Int(number)  {
            return value
        }
        return 0
    }

    func float(from object: Any?) -> Float {
        guard let string = object as? String, !string.isEmpty else { return 0.0 }

        if let value = Float(string)  {
            return value
        }
        return 0.0
    }
}
