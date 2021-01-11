//
//  User.swift
//  E2API
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation
import ObjectMapper

public class User: Mappable, Descriptable {

    public var id: ObjectId = ""
    public var username: String = ""
    public var country: String = ""
    public var phone: String?
    public var referralCode: String = ""
    public var imageUrl: String = ""
    public var propertyCount: Int = 0
    public var netWorth: Float = 0
    public var balance: Float = 0
    public var profitIncreaseNet: Float = 0
    public var profitIncreasePct: Float = 0

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
        username <- map["username"]
        country <- map["country"]

        referralCode <- map["referral_code"]
        imageUrl <- map["image_url"]
        propertyCount <- map["property_count"]
        netWorth <- map["net_worth"]
        balance <- map["balance"]
        profitIncreaseNet <- map["profit_increase_net"]
        profitIncreasePct <- map["profit_increase_pct"]

        if let value = map.JSON["phone"] as? String, value != "None" {
            phone <- map["phone"]
        }
    }
}
