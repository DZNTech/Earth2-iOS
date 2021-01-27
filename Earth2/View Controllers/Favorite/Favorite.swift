//
//  Favorite.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-18.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation

struct Favorite {
    let name: String
    let code: String
}

class FavoriteCache {

    func saveFavorites(_ favorites: [Favorite]) {
        var array = [[String: String]]()
        for favorite in favorites {
            array += [[AttributeKey.name: favorite.name, AttributeKey.code: favorite.code]]
        }

        UserDefaults.standard.set(array, forKey: FavoriteCache.cacheKey)
    }

    func getFavorites() -> [Favorite] {
        guard let array = UserDefaults.standard.object(forKey: FavoriteCache.cacheKey) as? [[String : String]] else { return [Favorite]() }
        return Favorite.favorites(for: array)
    }

    fileprivate static let cacheKey = "com.dzntech.e2.FavoriteCache"
}

fileprivate extension Favorite {

    static func favorites(for dictionaries: [[String : String]]) -> [Favorite] {
        var array = [Favorite]()

        for dict in dictionaries {
            guard let favorite = Favorite(from: dict) else { continue }
            array += [favorite]
        }
        return array
    }

    init?(from dict: [String : String]) {
        guard let name = dict[AttributeKey.name], let code = dict[AttributeKey.code] else { return nil }
        self.init(name: name, code: code)
    }
}

fileprivate enum AttributeKey {
    static let name = "name"
    static let code = "code"
}
