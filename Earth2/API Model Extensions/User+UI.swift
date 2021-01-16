//
//  User+UI.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-16.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import E2API

extension User {

    var qrImage: UIImage? {
        var qr = QRCode(with: referralCode)
        qr?.size = CGSize(square: 512)
        qr?.color = CIColor(color: UIColor.randomColor(seed: referralCode))
        qr?.backgroundColor = CIColor(color: Color.white)

        return qr?.image(with: UIImage(named: "e2_qr_watermark"))
    }
}
