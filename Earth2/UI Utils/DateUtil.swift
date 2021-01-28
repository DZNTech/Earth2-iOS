//
//  DateUtil.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-26.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation

public class DateUtil {

    static let standardFormat: String = "yyyy-MM-dd h:mm a"

    static let standardFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = DateUtil.standardFormat
        return formatter
    }()

    static let displayFullDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d @ h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()

    static let displayFullDateTimeYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy @ h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()

    static let displayDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EE, MMM d @ h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()

    static let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()

    static let formDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
}
