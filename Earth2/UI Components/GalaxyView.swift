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
            handleShowStarsUpdate()
        }
    }

    @IBInspectable
    public var showGradient: Bool = true {
        didSet {
            handleShowGradientUpdate()
        }
    }

    @IBInspectable
    public var topColor: UIColor = Color.blue {
        didSet {
            gradientLayer.colors = gradientColors
        }
    }

    @IBInspectable
    public var bottomColor: UIColor = Color.black {
        didSet {
            gradientLayer.colors = gradientColors
        }
    }

    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    func refreshStars() {
        guard showStars else { return }
        imageView.image = UIImage.generateStars(in: bounds)
    }

    // MARK: - Private Variables

    fileprivate lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = gradientColors
        return layer
    }()

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

    fileprivate func handleShowGradientUpdate() {
        if !showGradient {
            gradientLayer.removeFromSuperlayer()
        } else if gradientLayer.superlayer == nil {
            layer.insertSublayer(gradientLayer, at: 0)
        }
        gradientLayer.frame = bounds
    }

    fileprivate func handleShowStarsUpdate() {
        if !showStars {
            imageView.image = nil
        } else if imageView.superview == nil {
            imageView.image = UIImage.generateStars(in: bounds)
            imageView.frame = bounds
            addSubview(imageView)
        }
    }

    // MARK: - IB Visualization

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}

fileprivate extension UIImage {

    static func generateStars(in bounds: CGRect) -> UIImage {

        func insert(stars width: CGFloat, with count: Int, and color: UIColor, in view: UIView) {
            for _ in 0...count {
                let xPos: CGFloat = randomInRange(lo: 5, hi: Int(view.bounds.size.width-5)) // margin of 5
                let yPos: CGFloat = randomInRange(lo: 5, hi: Int(view.bounds.size.height-5))
                let rect = CGRect(x: xPos, y: yPos, width: width, height: width)
                let radius = width/2

                let starLayer = CAShapeLayer()
                starLayer.frame = rect
                starLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: radius*2, height: radius*2), cornerRadius: width/2).cgPath
                starLayer.fillColor = color.cgColor

                view.layer.insertSublayer(starLayer, at: 0)
            }
        }

        let view = UIView(frame: bounds)
        view.backgroundColor = .clear

        insert(stars: 3, with: 150, and: Color.white.withAlphaComponent(0.1), in: view)
        insert(stars: 4, with: 25, and: Color.white.withAlphaComponent(0.4), in: view)
        insert(stars: 6, with: 5, and: Color.white.withAlphaComponent(0.9), in: view)

        let renderer = UIGraphicsImageRenderer(bounds: bounds)

        return renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }
    }

    private static func randomInRange(lo: Int, hi : Int) -> CGFloat {
        return CGFloat(lo + Int(arc4random_uniform(UInt32(hi - lo + 1))))
    }
}
