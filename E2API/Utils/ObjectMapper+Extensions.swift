//
//  ObjectMapper+Extensions.swift
//  RaceSyncAPI
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation
import ObjectMapper

extension ImmutableMappable {

    static func from(JSON: [String : Any]) -> Self? {
        do {
            let mapped = try Self.init(JSON: JSON)
            return mapped
        } catch {
            return nil
        }
    }

}
