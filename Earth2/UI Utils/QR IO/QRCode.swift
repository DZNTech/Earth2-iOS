//
//  QRCode.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-15.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

/// QRCode generator
public struct QRCode {

    // MARK: Generate QRCode

    static func image(with string: String, color: UIColor = .black, backgroundColor: UIColor = .white, size: CGSize) -> UIImage? {
        guard var qr = QRCode(with: string) else { return nil }
        qr.color = color.ciColor
        qr.backgroundColor = backgroundColor.ciColor
        qr.size = size
        return qr.image
    }

    /// Image representation
    public var image: UIImage? {
        return getUIImage()
    }

    /// String value
    public var string: String {
        return String(decoding: data, as: UTF8.self)
    }

    /**
    The level of error correction.
    
    - Low:      7%
    - Medium:   15%
    - Quartile: 25%
    - High:     30%
    */
    enum ErrorCorrection: String {
        case Low = "L"
        case Medium = "M"
        case Quartile = "Q"
        case High = "H"
    }
    
    let data: Data

    var color = UIColor.black.ciColor
    var backgroundColor = UIColor.white.ciColor
    var size = CGSize(width: 200, height: 200)
    var errorCorrection = ErrorCorrection.Low
    
    // MARK: Initialization
    
    public init(with data: Data) {
        self.data = data
    }
    
    public init?(with string: String) {
        if let data = string.data(using: .isoLatin1) {
            self.data = data
        } else {
            return nil
        }
    }
    
    public init?(with url: URL) {
        if let data = url.absoluteString.data(using: .isoLatin1) {
            self.data = data
        } else {
            return nil
        }
    }
}

fileprivate extension QRCode {

    func getUIImage() -> UIImage? {
        guard let ciImage = getCIImage() else { return nil }

        // Size
        let ciImageSize = ciImage.extent.size
        let widthRatio = size.width / ciImageSize.width
        let heightRatio = size.height / ciImageSize.height

        return ciImage.nonInterpolatedImage(withScale: Scale(dx: widthRatio, dy: heightRatio))
    }

    /// The QRCode's CIImage representation
    func getCIImage() -> CIImage? {
        // Generate QRCode
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }

        qrFilter.setDefaults()
        qrFilter.setValue(data, forKey: "inputMessage")
        qrFilter.setValue(self.errorCorrection.rawValue, forKey: "inputCorrectionLevel")

        // Color code and background
        guard let colorFilter = CIFilter(name: "CIFalseColor") else { return nil }

        colorFilter.setDefaults()
        colorFilter.setValue(qrFilter.outputImage, forKey: "inputImage")
        colorFilter.setValue(color, forKey: "inputColor0")
        colorFilter.setValue(backgroundColor, forKey: "inputColor1")

        return colorFilter.outputImage
    }
}
