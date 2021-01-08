//
//  User.swift
//  E2API
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//

import Foundation
import ObjectMapper

public class User: ImmutableMappable {

    public let id: ObjectId
    public let username: String
    public let country: String
    public let phone: String?
    public let referralCode: String
    public let imageUrl: String
    public let propertyCount: Int
    public let netWorth: Double
    public let balance: Double
    public let propertyIncreaseNet: Double
    public let propertyIncreasePct: Double

    // MARK: - Initialization

    required public init(map: Map) throws {
        id = try map.value("id")
        username = try map.value("username")
        country = try map.value("country")
        phone = try? map.value("phone")
        referralCode = try map.value("referral_code")
        imageUrl = try map.value("image_url")
        propertyCount = try map.value("property_count")
        netWorth = try map.value("net_worth")
        balance = try map.value("balance")
        propertyIncreaseNet = try map.value("property_increase_net")
        propertyIncreasePct = try map.value("property_increase_pct")
    }
}
