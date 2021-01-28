//
//  Shimmable.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-26.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import ShimmerSwift

protocol Shimmable {
    var shimmeringView: ShimmeringView { get }

    func displayShimmer(_ display: Bool)
    static func defaultShimmeringView() -> ShimmeringView
}

extension Shimmable where Self: UIViewController {

    func displayShimmer(_ display: Bool) {
        guard shimmeringView.isShimmering != display else { return }

        shimmeringView.isShimmering = display
        view.isUserInteractionEnabled = !display

        if display {
            shimmeringView.isHidden = false
            shimmeringView.alpha = 1
        } else {
            UIView.animate(withDuration: 0.3) {
                self.shimmeringView.alpha = 0
            } completion: { (finished) in
                self.shimmeringView.isHidden = true
            }
        }
    }

    static func defaultShimmeringView() -> ShimmeringView {
        let view = ShimmeringView()
        view.backgroundColor = Color.clear
        view.contentView = tableViewCellShimmerView()
        view.shimmerAnimationOpacity = 0.4
        view.shimmerOpacity = 1.0
        view.shimmerPauseDuration = 0.3
        view.shimmerSpeed = 300
        view.isHidden = true
        return view
    }

    static fileprivate func tableViewCellShimmerView() -> UIView {
        let view = UIView()
        guard let image = UIImage(named: "placeholder_shimmer_list") else { return view }

        let cellHeight = image.size.height
        let screenHeight = UIScreen.main.bounds.height
        let count: Int = abs(Int(screenHeight/cellHeight) + 1)

        for i in 0 ..< count {
            let imageView = UIImageView(image: image)

            if i > 0 {
                imageView.frame.origin.y = cellHeight * CGFloat(i-1)
            }

            view.addSubview(imageView)
        }

        return view
    }
}
