//
//  GalaxyView.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-09.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

@IBDesignable
class GalaxyView: UIView {

    // MARK: - Public Variables

    @IBInspectable
    public var showStars: Bool = true {
        didSet {
            updateStarsComposition()
        }
    }

    @IBInspectable
    public var showGradient: Bool = true {
        didSet {
            updateGradient()
        }
    }

    @IBInspectable
    public var topColor: UIColor = Color.blue {
        didSet {
            updateGradient()
        }
    }

    @IBInspectable
    public var bottomColor: UIColor = Color.black {
        didSet {
            updateGradient()
        }
    }

    func refreshStars() {
        updateStarsComposition()
    }

    func getSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    // MARK: - Private Variables

    fileprivate var galaxyLayer: CALayer?
    fileprivate var gradientLayer: CAGradientLayer?

    fileprivate var gradientColors: [CGColor] {
        return [topColor.cgColor, bottomColor.cgColor]
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Layout

    fileprivate func updateGradient() {
        if let layer = gradientLayer {
            layer.removeFromSuperlayer()
        }

        if showGradient {
            let gradient = CAGradientLayer()
            gradient.frame = bounds
            gradient.colors = gradientColors

            layer.insertSublayer(gradient, at: 0)
            gradientLayer = gradient
        }
    }

    fileprivate func updateStarsComposition() {
        if let layer = galaxyLayer {
            layer.removeFromSuperlayer()
        }

        if showStars {
            let galaxy = GalaxyComposer.galaxyAsLayer(in: bounds)
            galaxy.frame = bounds

            layer.insertSublayer(galaxy, at: 1)
            galaxyLayer = galaxy
        }
    }

    // MARK: - IB Visualization

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}
