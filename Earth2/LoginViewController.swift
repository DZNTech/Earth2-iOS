//
//  LoginViewController.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import SnapKit
import E2API

class LoginViewController: UIViewController {

    // MARK: - Public Variables


    // MARK: - Private Variables

    fileprivate lazy var loginFormView: UIView = {
        let view = UIView()
        view.alpha = 1
        view.backgroundColor = Color.clear
        view.addSubview(self.legendLabel)
        view.addSubview(self.emailField)
        view.addSubview(self.passwordField)
        view.addSubview(self.passwordRecoveryButton)
        view.addSubview(self.createAccountButton)
//        view.addSubview(self.loginButton)
//        view.addSubview(self.legalButton)
        return view
    }()

    fileprivate lazy var legendLabel: UILabel = {
        let label = UILabel()
        label.text = "Login with earth2.io credentials"
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = Color.white
        return label
    }()

    fileprivate lazy var emailField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .next
        textField.textContentType = .emailAddress
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.textColor = Color.white.withAlphaComponent(0.9)
        textField.backgroundColor = Color.darkBlue.withAlphaComponent(0.9)
        textField.borderStyle = .roundedRect
        textField.setPlaceholder("Email", with: Color.white.withAlphaComponent(0.3))
        textField.setClearButton(color: Color.white.withAlphaComponent(0.3))
        return textField
    }()

    fileprivate lazy var passwordField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.keyboardType = .`default`
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .`continue`
        textField.textContentType = .password
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.textColor = Color.white.withAlphaComponent(0.9)
        textField.backgroundColor = Color.darkBlue.withAlphaComponent(0.9)
        textField.borderStyle = .roundedRect
        textField.setPlaceholder("Password", with: Color.white.withAlphaComponent(0.3))
        textField.setClearButton(color: Color.white.withAlphaComponent(0.3))
        return textField
    }()

    fileprivate lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = Color.white
        return label
    }()

    fileprivate lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(Color.lightBlue, for: .normal)
        button.setTitle("Create an account", for: .normal)
        button.addTarget(self, action:#selector(didPressCreateAccountButton), for: .touchUpInside)
        return button
    }()

    fileprivate lazy var passwordRecoveryButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(Color.lightBlue, for: .normal)
        button.setTitle("Forgot your password?", for: .normal)
        button.addTarget(self, action:#selector(didPressPasswordRecoveryButton), for: .touchUpInside)
        return button
    }()

    @IBOutlet fileprivate var launchImageView: UIImageView!
    @IBOutlet fileprivate var galaxyView: GalaxyView!
    @IBOutlet fileprivate var titleLabel: UILabel!
    @IBOutlet fileprivate var subtitleLabel: UILabel!
    @IBOutlet fileprivate var launchView: UIView!

    fileprivate let authApi = AuthApi()
    fileprivate let propertyApi = PropertyApi()

    fileprivate enum Constants {
        static let padding: CGFloat = UniversalConstants.padding
    }

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

        pimpLaunch()

        launchView.isHidden = true

        view.addSubview(loginFormView)
        loginFormView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Constants.padding)
            $0.trailing.equalToSuperview().offset(-Constants.padding)
            $0.height.greaterThanOrEqualTo(320)

//            loginFormViewCenterYConstraint = $0.centerY.equalToSuperview().constraint
//            loginFormViewCenterYConstraint?.activate()
        }

        legendLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
        }

        emailField.snp.makeConstraints {
            $0.top.equalTo(legendLabel.snp.bottom).offset(Constants.padding*1.5)
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(40)
        }

        passwordField.snp.makeConstraints {
            $0.top.equalTo(emailField.snp.bottom).offset(Constants.padding*1.5)
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(40)
        }

        passwordRecoveryButton.snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(Constants.padding*1.5)
            $0.leading.equalToSuperview()
        }

        createAccountButton.snp.makeConstraints {
            $0.top.equalTo(passwordRecoveryButton.snp.bottom).offset(Constants.padding/2)
            $0.leading.equalToSuperview()
        }
    }

    fileprivate func pimpLaunch() {
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

    @objc func didPressLoginButton() {
        //
    }

    @objc func didPressCreateAccountButton() {
        //
    }

    @objc func didPressPasswordRecoveryButton() {
        //
    }

    @objc func didTapLaunchView() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.4
        animation.values = [-20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        launchImageView.layer.add(animation, forKey: "shake")
    }
}

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        //
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        //
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            didPressLoginButton()
        }

        return true
    }
}
