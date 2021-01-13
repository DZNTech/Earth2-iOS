//
//  PropertyViewModel.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-12.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import E2API

public class PropertyViewModel: Descriptable {

    let property: Property

    let landLabel: String
    let tilesLabel: String
    let tileValueLabel: String
    let marketValueLabel: String

    let imageUrl: String?

    // MARK: - Initializatiom

    init(with property: Property) {
        self.property = property

        self.landLabel = PropertyViewModel.landLabelString(for: property)
        self.tilesLabel = PropertyViewModel.tilesLabelString(for: property)
        self.tileValueLabel = PropertyViewModel.tileValueLabelString(for: property)
        self.marketValueLabel = PropertyViewModel.marketValueLabelString(for: property)

        self.imageUrl = Web.convertMapBoxUrl(from: property.imageUrl, with: CGSize.init(square: 200))
    }
}

fileprivate extension PropertyViewModel {

    static func landLabelString(for property: Property) -> String {
        return "\(FlagEmojiGenerator.flag(country: property.countryCode)) \(property.landTitle)"
    }

    static func tilesLabelString(for property: Property) -> String {
        if property.tilesCount > 1 {
            return "\(property.tilesCount) tiles"
        }
        return "\(property.tilesCount) tile"
    }

    static func tileValueLabelString(for property: Property) -> String {
        return "$\(property.tileValue) / tile"
    }

    static func marketValueLabelString(for property: Property) -> String {
        return "$\(property.marketValue)"
    }

    static func profitPctLabelString(for percentage: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = percentage < 1000 ? 2 : 0

        var string = String()

        if percentage > 100 {
            string += "+"
        } else if percentage < 100 {
            string += "-"
        }

        if let formattedString = formatter.string(from: percentage as NSNumber) {
            string += formattedString
        }

        return "\(string)%"
    }

    static func profitColor(for percentage: Float) -> UIColor {
        if percentage > 100 {
            return Color.green
        } else if percentage < 100 {
            return Color.green
        } else {
            return Color.white
        }
    }
}
