//
//  Vibrator.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-27.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import AVFoundation

class Vibrator {

    static func vibrate() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}
