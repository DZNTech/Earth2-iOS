//
//  QRCodeTests.swift
//  Earth2Tests
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-15.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import XCTest
import Earth2

class QRCodeTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testQRGeneration() throws {

        let url = "https://earth2.io/"
        let qr = QRCode(with: url)

        XCTAssertNotNil(qr?.image)
        XCTAssertEqual(qr?.string, url)

        let scan = qr?.image?.stringFromQR()
        XCTAssertEqual(scan, url)
    }

    func testQRScanFromImage() throws {

        let url = "https://earth2.io/"
        let qr = QRCode(with: url)

        let scan = qr?.image?.stringFromQR()
        XCTAssertEqual(scan, url)
    }
}
