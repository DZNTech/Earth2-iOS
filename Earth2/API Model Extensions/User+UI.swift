//
//  User+UI.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-16.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

extension QRCode {

    static func e2QRImage(with username: String, referralCode: String, width: CGFloat = 512) -> UIImage?  {
        let string = "\(referralCode)---\(username)"
        let color = UIColor.randomColor(seed: referralCode)
        return QRCode.image(with: string, color: color, backgroundColor: .white, size:  CGSize(square: width))

//        return qr?.image(with: UIImage(named: "e2_qr_watermark"))
    }
}
