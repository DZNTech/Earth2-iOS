//
//  UserTests.swift
//  E2APITests
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-12.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import XCTest
import E2API

class UserTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testUsersMapping() {
        guard let dict = JSONUtil.getLocalJSONObject(for: "users/login/") else {
            XCTFail()
            return
        }

        let user = User.init(JSON: dict)
        XCTAssertEqual(user?.id, "609c3f3c-c65a-46c6-98b4-d09ec1da979c")
    }
}

