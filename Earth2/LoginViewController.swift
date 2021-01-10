//
//  LoginViewController.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import E2API

class LoginViewController: UIViewController {

    // MARK: - Public Variables


    // MARK: - Private Variables

    fileprivate let authApi = AuthApi()
    fileprivate let propertyApi = PropertyApi()

    @IBOutlet fileprivate var launchImageView: UIImageView!
    @IBOutlet fileprivate var galaxyView: GalaxyView!
    @IBOutlet fileprivate var titleLabel: UILabel!
    @IBOutlet fileprivate var subtitleLabel: UILabel!

    // MARK: - View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    // MARK: - Layout

    fileprivate func setupLayout() {

        view.bringSubviewToFront(launchImageView)

        let launchTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLaunchView))
        launchImageView.addGestureRecognizer(launchTapGesture)
        launchImageView.isUserInteractionEnabled = true
        launchImageView.addGlow(with: UIColor(hex: "00b0f4"), radius: 30, opacity: 0.25)

        let backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(backgroundTapGesture)

        titleLabel.addCharacterSpacing(kernValue: 13)
        titleLabel.addGlow(with: Color.blue, radius: 3)

        subtitleLabel.addCharacterSpacing(kernValue: 9)
        subtitleLabel.addGlow(with: Color.black, radius: 3)
    }

    // MARK: - Actions

    fileprivate func loadContent() {

        authApi.login("", password: "") { (user, error) in
            //
        }

        propertyApi.getMyProperties { (properties, error) in
            //
        }
    }

    // MARK: - Actions

    @objc func didTapView() {
        galaxyView?.refreshStars()
    }

    @objc func didTapLaunchView() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.4
        animation.values = [-20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        launchImageView.layer.add(animation, forKey: "shake")
    }
}
