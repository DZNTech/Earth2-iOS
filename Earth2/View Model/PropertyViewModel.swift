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

    let tilesLabel: String
    let marketValueLabel: String
    let profitPctLabel: String
    let profitColor: UIColor

    // MARK: - Initializatiom

    init(with property: Property) {
        self.property = property

        self.tilesLabel = PropertyViewModel.tilesLabelString(for: property)
        self.marketValueLabel = PropertyViewModel.marketValueLabelString(for: property)
        self.profitPctLabel = PropertyViewModel.profitPctLabelString(for: property)
        self.profitColor = PropertyViewModel.profitColor(for: property)
    }
}

fileprivate extension PropertyViewModel {

    static func tilesLabelString(for property: Property) -> String {
        return "\(property.tilesCount) tiles ($\(property.val))"
    }

    static func marketValueLabelString(for property: Property) -> String {
        return "$\(property.marketValue)"
    }

    static func profitPctLabelString(for property: Property) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = property.profitPct < 1000 ? 2 : 0

        var string = String()

        if property.profitPct > 100 {
            string += "+"
        } else if property.profitPct < 100 {
            string += "-"
        }

        if let formattedString = formatter.string(from: property.profitPct as NSNumber) {
            string += formattedString
        }

        return "\(string)%"
    }

    static func profitColor(for property: Property) -> UIColor {
        if property.profitPct > 100 {
            return Color.green
        } else if property.profitPct < 100 {
            return Color.green
        } else {
            return Color.white
        }
    }
}
