//
//  WebTests.swift
//  E2APITests
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-11.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import XCTest
import E2API
import Alamofire

class WebTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testMapBoxURLConvertion() {
        let sourceUrl = "https://api.mapbox.com/styles/v1/mapbox/satellite-v9/static/-123.167897, 49.177271}, 16.0, 0.0, 0.0/520x400?access_token=pk.eyJ1IjoiZXYyIiwiYSI6ImNraHB6cXVtcjA0emkycm84cTBxdnBscGkifQ.VX6qEmMYgvhYBCZJKzJ2cA"
        let expectedUrl = "https://api.mapbox.com/styles/v1/mapbox/satellite-v9/static/-123.167897, 49.177271}, 16.0, 0.0, 0.0/20x20?access_token=pk.eyJ1IjoiZHpuIiwiYSI6ImNranN3dnVpNDA0eXozM3FzcjlxMzIweXkifQ.bFoLTSgzwGTaoVfmUQ5XYw"

        let convertedUrl = Web.convertUrl(from: sourceUrl, with: CGSize(width: 20, height: 20))

        XCTAssertEqual(convertedUrl, expectedUrl)
    }

    func testAWSURLIgnore() {
        let sourceUrl = "https://s3-ap-southeast-2.amazonaws.com/prod-app-media.earth2.io/thumbnails/89a90ec5-967c-48a2-9c5b-777c083ca480.jpg"

        let convertedUrl = Web.convertUrl(from: sourceUrl, with: CGSize(width: 20, height: 20))

        XCTAssertEqual(sourceUrl, convertedUrl)
    }


}
