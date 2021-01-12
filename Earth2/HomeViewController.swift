//
//  HomeViewController.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-10.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import SnapKit
import E2API

class HomeViewController: UIViewController {

    // MARK: - Public Variables

    // MARK: - Private Variables

    fileprivate lazy var backgroundView: GalaxyView = {
        let view = GalaxyView(frame: self.view.bounds)
        view.showStars = true
        view.showGradient = true
        view.topColor = Color.black
        view.bottomColor = Color.darkBlue
        return view
    }()

    fileprivate let propertyApi = PropertyApi()

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

        self.view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
    }

    fileprivate func loadContent() {
        propertyApi.getMyProperties { (properties, error) in
            //
        }
    }
}
