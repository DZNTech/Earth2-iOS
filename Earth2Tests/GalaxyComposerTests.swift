//
//  GalaxyComposerTests.swift
//  Earth2Tests
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-11.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import XCTest
import Earth2

class GalaxyComposerTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testPerformanceGalaxyAsImage() throws {
        let bounds = UIScreen.main.bounds

        measure {
            let _ = GalaxyComposer.generateStars(in: bounds)
        }
    }

    func testPerformanceGalaxyAsLayer() throws {
        let bounds = UIScreen.main.bounds

        measure { //0.004s vs 0.014 s
            let _ = GalaxyComposer.generateStarsLayer(in: bounds)
        }
    }

}
