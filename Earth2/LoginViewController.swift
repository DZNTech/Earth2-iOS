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
import SwiftValidators

class LoginViewController: UIViewController {

    // MARK: - Public Variables


    // MARK: - Private Variables

    fileprivate lazy var loginFormView: UIView = {
        let view = UIView()
        view.alpha = 1
        view.backgroundColor = Color.white.withAlphaComponent(0.0125)
        view.layer.cornerRadius = 8

        view.addSubview(self.legendLabel)
        view.addSubview(self.emailField)
        view.addSubview(self.passwordField)
        view.addSubview(self.passwordRecoveryButton)
        view.addSubview(self.createAccountButton)
        return view
    }()

    fileprivate lazy var legendLabel: UILabel = {
        let label = UILabel()
        label.text = "Login with earth2.io"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = Color.white.withAlphaComponent(0.7)
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
        textField.text = E2APIServices.shared.credential.email
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
        textField.text = E2APIServices.shared.credential.password
        textField.setPlaceholder("Password", with: Color.white.withAlphaComponent(0.3))
        textField.setClearButton(color: Color.white.withAlphaComponent(0.3))
        return textField
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

    fileprivate lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = Color.white
        label.textAlignment = .center
        return label
    }()

    fileprivate lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = Color.white
        view.hidesWhenStopped = true
        return view
    }()

    // IB
    @IBOutlet fileprivate var launchImageView: UIImageView!
    @IBOutlet fileprivate var galaxyView: GalaxyView!
    @IBOutlet fileprivate var titleLabel: UILabel!
    @IBOutlet fileprivate var subtitleLabel: UILabel!
    @IBOutlet fileprivate var launchView: UIView!
    @IBOutlet fileprivate var launchViewCenterYConstraint: NSLayoutConstraint?
    @IBOutlet fileprivate var launchImageViewHeightConstraint: NSLayoutConstraint?

    fileprivate var loginFormViewCenterYConstraint: Constraint?
    fileprivate var loginFormIntersection: CGRect = .zero
    fileprivate var launchViewViewHalfHeight: CGFloat = 0

    fileprivate var isKeyboardVisible: Bool = false

    // API
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Skip login if there's a persisted sessionId
        if E2APIServices.shared.isLoggedIn {
            // present home vc
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
                self.emailField.becomeFirstResponder()
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    // MARK: - Layout

    fileprivate func setupLayout() {

        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(viewTapGesture)

        galaxyView.topColor = Color.blue
        galaxyView.bottomColor = Color.black

        launchImageView.isUserInteractionEnabled = true
        launchImageView.addGlow(with: UIColor(hex: "00b0f4"), radius: 30, opacity: 0.25)
        view.bringSubviewToFront(launchImageView)

        titleLabel.addCharacterSpacing(kernValue: 13)
        titleLabel.addGlow(with: Color.blue, radius: 3)

        subtitleLabel.addCharacterSpacing(kernValue: 9)
        subtitleLabel.addGlow(with: Color.black, radius: 3)

        activityIndicatorView.startAnimating()

        view.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-Constants.padding*5)
        }

        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(activityIndicatorView.snp.bottom).offset(Constants.padding)
        }

        layoutLoginForm()
        setupObservers()
    }

    fileprivate func layoutLoginForm() {

        loginFormView.alpha = 0

        view.addSubview(loginFormView)
        loginFormView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(Constants.padding*2)
            $0.trailing.equalToSuperview().offset(-Constants.padding*2)

            loginFormViewCenterYConstraint = $0.centerY.equalToSuperview().constraint
            loginFormViewCenterYConstraint?.activate()
        }

        legendLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.padding*2)
            $0.leading.equalToSuperview().offset(Constants.padding*2)
            $0.trailing.equalToSuperview().offset(-Constants.padding*2)
        }

        emailField.snp.makeConstraints {
            $0.top.equalTo(legendLabel.snp.bottom).offset(Constants.padding*1.5)
            $0.leading.equalToSuperview().offset(Constants.padding*2)
            $0.trailing.equalToSuperview().offset(-Constants.padding*2)
            $0.height.greaterThanOrEqualTo(40)
        }

        passwordField.snp.makeConstraints {
            $0.top.equalTo(emailField.snp.bottom).offset(Constants.padding*1)
            $0.leading.equalToSuperview().offset(Constants.padding*2)
            $0.trailing.equalToSuperview().offset(-Constants.padding*2)
            $0.height.greaterThanOrEqualTo(40)
        }

        passwordRecoveryButton.snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(Constants.padding*2)
            $0.leading.equalToSuperview().offset(Constants.padding*2)
        }

        createAccountButton.snp.makeConstraints {
            $0.top.equalTo(passwordRecoveryButton.snp.bottom).offset(Constants.padding/2)
            $0.leading.equalToSuperview().offset(Constants.padding*2)
            $0.bottom.equalToSuperview().offset(-Constants.padding*2)
        }

        launchViewViewHalfHeight = launchImageView.frame.height/2
    }

    fileprivate func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    fileprivate func presentHome() {
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: true, completion: nil)
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
        if emailField.isFirstResponder {
            emailField.resignFirstResponder()
        } else if passwordField.isFirstResponder {
            passwordField.resignFirstResponder()
        } else {
            galaxyView?.refreshStars()
        }
    }

    fileprivate func handleReturnKey(for textField: UITextField) {

        func validateEmail() -> Bool {
            guard let email = emailField.text else { shakeLaunchImageView(); return false }
            guard Validator.isEmail().apply(email) else { shakeLaunchImageView(); return false }
            return true
        }

        func validatePassword() -> Bool {
            guard let password = passwordField.text, !Validator.isEmpty().apply(password) else { shakeLaunchImageView(); return false }
            return true
        }

        func prepareToSubmit() {
            textField.resignFirstResponder()
            loginFormView.isUserInteractionEnabled = false
            loginFormView.alpha = 0.5

            presentHome()
        }

        if textField == emailField, validateEmail() {
            if validatePassword() {
                prepareToSubmit()
            } else {
                passwordField.becomeFirstResponder()
            }
        } else if textField == passwordField, validatePassword() {
            if validateEmail() {
                prepareToSubmit()
            } else {
                emailField.becomeFirstResponder()
                emailField.returnKeyType = .`continue`
            }
        }
    }

    @objc func didPressCreateAccountButton() {
        //
    }

    @objc func didPressPasswordRecoveryButton() {
        //
    }

    @objc func shakeLaunchImageView() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.4
        animation.values = [-20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        launchImageView.layer.add(animation, forKey: "shake")
    }

    // MARK: - Actions

    @objc func keyboardWillShow(_ notification: Notification) {
        guard !isKeyboardVisible else { return }
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardRect = keyboardFrame.cgRectValue
        loginFormIntersection = keyboardRect.intersection(loginFormView.frame)

        let loginFormRect = loginFormView.frame
        let launchViewViewCenterY = loginFormIntersection.height + loginFormRect.height + Constants.padding

        UIView.animate(withDuration: 0, // inherits the animation duration from the keyboard's
                       delay: 0,
                       options: []) {
            self.launchViewCenterYConstraint?.constant = -launchViewViewCenterY
            self.launchImageViewHeightConstraint?.constant = self.launchViewViewHalfHeight
            self.loginFormViewCenterYConstraint?.update(offset: -self.loginFormIntersection.height)
            self.galaxyView.imageView.setY(-self.loginFormIntersection.height)

            self.loginFormView.alpha = 1
            self.titleLabel.alpha = 0
            self.subtitleLabel.alpha = 0

            self.view.layoutIfNeeded()
        } completion: { (finished) in

        }

        isKeyboardVisible = true
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        guard isKeyboardVisible else { return }

        UIView.animate(withDuration: 0, // inherits the animation duration from the keyboard's
                       animations: {
                        self.launchViewCenterYConstraint?.constant += self.loginFormIntersection.height
                        self.loginFormViewCenterYConstraint?.update(offset: 0)
                        self.galaxyView.imageView.setY(0)

                        self.view.layoutIfNeeded()
        },
                       completion: nil)

        isKeyboardVisible = false
    }

    fileprivate func moveGalaxy(_ position: CGFloat, duration: TimeInterval) {
        let animation = CAKeyframeAnimation(keyPath: "galaxyView.imageView.frame.y")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.keyPath = "position.y"
        animation.values = [0, position]
        animation.keyTimes = [0, 1]
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        galaxyView.imageView.layer.add(animation, forKey: "move")
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
        handleReturnKey(for: textField)
        return true
    }
}
