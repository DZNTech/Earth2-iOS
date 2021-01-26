//
//  PropertyTests.swift
//  E2APITests
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-12.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import XCTest
import E2API

class PropertyTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testPropertiesMapping() {
        guard let dict = JSONUtil.getLocalDictObjects(for: "users/properties/") else {
            XCTFail()
            return
        }

        let properties = Property.properties(for: dict)
        let property = properties.first

        XCTAssertEqual(property?.location, "Tefé, Amazonas, Brazil")
        XCTAssertEqual(property?.country, "Brazil")
        XCTAssertEqual(property?.countryCode, "BR")

        XCTAssertEqual(property?.tilesCount, 3)
        XCTAssertEqual(property?.tileValue, 1.70)
        XCTAssertEqual(property?.marketValue, 5.09)
    }
}
