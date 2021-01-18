//
//  Color.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

// Color Palette
public struct Color {
    // RGB
    public static let paleBlue: UIColor =       #colorLiteral(red: 0.5333333333, green: 0.5254901961, blue: 0.6274509804, alpha: 1) // #8886a0
    public static let lightBlue: UIColor =      #colorLiteral(red: 0.1882352941, green: 0.4823529412, blue: 0.968627451, alpha: 1) // #307bf7
    public static let blue: UIColor =           #colorLiteral(red: 0.1333333333, green: 0.09019607843, blue: 0.368627451, alpha: 1) // #22175e
    public static let darkBlue: UIColor =       #colorLiteral(red: 0.04705882353, green: 0.03921568627, blue: 0.1607843137, alpha: 1) // #0c0a29
    public static let darkerBlue: UIColor =     #colorLiteral(red: 0.0431372549, green: 0.03137254902, blue: 0.137254902, alpha: 1) // #0b0823

    public static let green: UIColor =          #colorLiteral(red: 0.1568627451, green: 0.7294117647, blue: 0.2666666667, alpha: 1) // #28ba44
    public static let yellow: UIColor =         #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1) // #F3AF22
    public static let red: UIColor =            #colorLiteral(red: 0.9286758304, green: 0.1982205212, blue: 0.1717652977, alpha: 1) // #DA4538

    // Grayscale
    public static let white: UIColor =          #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // #FFFFFF
    public static let gray20: UIColor =         #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.968627451, alpha: 1) // #f5f6f7
    public static let gray50: UIColor =         #colorLiteral(red: 0.9294117647, green: 0.9254901961, blue: 0.9333333333, alpha: 1) // #EDECEE
    public static let gray100: UIColor =        #colorLiteral(red: 0.7921568627, green: 0.7921568627, blue: 0.7921568627, alpha: 1) // #CACACA
    public static let gray200: UIColor =        #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1) // #8E8E93
    public static let gray300: UIColor =        #colorLiteral(red: 0.4274509804, green: 0.4274509804, blue: 0.4470588235, alpha: 1) // #6D6D72
    public static let gray400: UIColor =        #colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.262745098, alpha: 1) // #434343
    public static let gray500: UIColor =        #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1568627451, alpha: 1) // #222228
    public static let black: UIColor =          #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) // #000000
    public static let clear: UIColor =          #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) // #00000000

    // UI specific
    public static let navigationBarColor =      Color.white
}

