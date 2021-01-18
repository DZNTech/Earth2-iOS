//
//  FavoritesViewController.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-12.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import SnapKit
import E2API
import PanModal

class FavoritesViewController: UITabBarController {

    // MARK: - Public Variables

    // MARK: - Private Variables

    fileprivate enum Constants {
        static let padding: CGFloat = UniversalConstants.padding
    }

    // MARK: - View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    // MARK: - Layout

    fileprivate func setupLayout() {
        view.backgroundColor = Color.white

        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(hex: "222225")
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
    }
}

extension FavoritesViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(view.frame.width)
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(view.frame.width)
    }

    var panModalBackgroundColor: UIColor {
        return UIColor(white: 0, alpha: 0.2)
    }

    var dragIndicatorBackgroundColor: UIColor {
        return Color.gray300.withAlphaComponent(0.7)
    }
}
