//
//  ApiError.swift
//  RaceSyncAPI
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation
import ObjectMapper

struct ApiError: ImmutableMappable {

    let code: Int
    let message: String

    init(map: Map) throws {
        code = (try? map.value("httpStatus")) ?? -1
        message = try map.value("statusDescription")
    }
}
