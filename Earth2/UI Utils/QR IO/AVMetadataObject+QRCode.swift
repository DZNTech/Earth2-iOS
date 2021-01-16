//
//  AVMetadataObject+QRCode.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-15.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import AVFoundation

extension AVMetadataObject {

    func stringFromQR() -> String? {
        guard let readableObject = self as? AVMetadataMachineReadableCodeObject else { return nil }
        guard let stringValue = readableObject.stringValue else { return nil }
        return stringValue
    }
}
