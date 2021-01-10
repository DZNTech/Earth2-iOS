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

    override var backgroundColor: UIColor? {
        didSet {

        }
    }

    func refreshStars() {
        guard showStars else { return }
        imageView.image = UIImage.generateStars(in: bounds)
    }

    // MARK: - Private Variables

    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    fileprivate lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [Color.clear.cgColor, Color.darkBlue.cgColor]
        return layer
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)  // break point 3
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)  // break point 4
        setup()
    }

    // MARK: - Layout

    fileprivate func setup() {
        self.backgroundColor = Color.blue
    }

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
        setup()
    }
}

fileprivate extension UIImage {

    static func generateStars(in bounds: CGRect) -> UIImage {

        func insert(stars width: CGFloat, with count: Int, and color: UIColor, in view: UIView) {
            for _ in 0...count {
                let xPos: CGFloat = randomInRange(lo: 5, hi: Int(view.bounds.size.width-5)) // margin of 5
                let yPos: CGFloat = randomInRange(lo: 5, hi: Int(view.bounds.size.height-5))

                let star = CALayer() // more efficient than UIView
                star.frame = CGRect(x: xPos, y: yPos, width: width, height: width)
                star.backgroundColor = color.cgColor
                star.cornerRadius = width/2

                view.layer.insertSublayer(star, at: 0)
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
