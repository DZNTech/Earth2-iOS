//
//  GalaxyComposer.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-11.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

public class GalaxyComposer {

    public static func galaxyAsLayer(in bounds: CGRect) -> CALayer {
        let layer = CALayer.init()
        layer.bounds = bounds
        layer.backgroundColor = UIColor.clear.cgColor

        guard !bounds.isEmpty else { return layer }

        func insert(stars width: CGFloat, with count: Int, and color: UIColor, in layer: CALayer) {
            for _ in 0...count {
                let xPos: CGFloat = randomInRange(lo: 5, hi: Int(layer.bounds.size.width-5)) // margin of 5
                let yPos: CGFloat = randomInRange(lo: 5, hi: Int(layer.bounds.size.height-5))
                let rect = CGRect(x: xPos, y: yPos, width: width, height: width)
                let radius = width/2

                let starLayer = CAShapeLayer()
                starLayer.frame = rect
                starLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: radius*2, height: radius*2), cornerRadius: width/2).cgPath
                starLayer.fillColor = color.cgColor

                layer.insertSublayer(starLayer, at: 0)
            }
        }

        let resolution = bounds.size.width * bounds.size.height

        let sCount = Int(resolution * 0.0005)    // small stars based on 5000% of resolution
        let mCount = Int(resolution * 0.000075)  // medium stars based on 75000% of resolution
        let lCount = Int(resolution * 0.0000125) // large stars based on 125000% of resolution

        insert(stars: 3, with: sCount, and: Color.white.withAlphaComponent(0.1), in: layer)
        insert(stars: 4, with: mCount, and: Color.white.withAlphaComponent(0.4), in: layer)
        insert(stars: 6, with: lCount, and: Color.white.withAlphaComponent(0.9), in: layer)
        insert(stars: 4, with: 0, and: UIColor(hex: "ffdc92").withAlphaComponent(0.5), in: layer) // 1x sun
        insert(stars: 3, with: 0, and: UIColor(hex: "93dffd").withAlphaComponent(0.7), in: layer) // 1x venus

        return layer
    }

    public static func galaxyAsImage(in bounds: CGRect) -> UIImage {
        guard !bounds.isEmpty else { return UIImage() }

        let layer = galaxyAsLayer(in: bounds)

        let view = UIView(frame: bounds)
        view.backgroundColor = .clear
        view.layer.insertSublayer(layer, at: 0)

        let renderer = UIGraphicsImageRenderer(bounds: bounds)

        return renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }
    }

    private static func randomInRange(lo: Int, hi : Int) -> CGFloat {
        return CGFloat(lo + Int(arc4random_uniform(UInt32(hi - lo + 1))))
    }
}
