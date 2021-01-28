//
//  UIImageView+QRCode.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-15.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import CoreImage

public extension UIImageView {
    
    /// Creates a new image view with the given QRCode
    ///
    /// - parameter qrCode:      The QRCode to display in the image view
    convenience init(qrCode: QRCode) {
        self.init(image: qrCode.image)
    }
}

public extension UIImage {

    func stringFromQR() -> String? {
        guard let image = CIImage(image: self) else { return nil }

        let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                  context: nil,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])

        let features = detector?.features(in: image) ?? []

        return features.compactMap { feature in
            return (feature as? CIQRCodeFeature)?.messageString
        }.first
    }
}
