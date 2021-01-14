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
        view.backgroundColor = Color.white.withAlphaComponent(0.025)
        view.layer.cornerRadius = 8
        return view
    }()

    fileprivate lazy var legendLabel: UILabel = {
        let label = UILabel()
        label.text = "Login with earth2.io"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = Color.white.withAlphaComponent(0.5)
        return label
    }()

    fileprivate lazy var emailField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.keyboardType = .emailAddress
        textField.keyboardAppearance = .dark
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .next
        textField.textContentType = .emailAddress
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.borderStyle = .roundedRect
        textField.textColor = Color.white.withAlphaComponent(0.9)
        textField.backgroundColor = Color.darkBlue.withAlphaComponent(0.9)
        textField.text = APIServices.shared.credential.email
        textField.setPlaceholder("Email", with: Color.white.withAlphaComponent(0.3))
        textField.setClearButton(color: Color.white.withAlphaComponent(0.3))
        return textField
    }()

    fileprivate lazy var passwordField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.keyboardType = .`default`
        textField.keyboardAppearance = .dark
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .`continue`
        textField.textContentType = .password
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.borderStyle = .roundedRect
        textField.textColor = Color.white.withAlphaComponent(0.9)
        textField.backgroundColor = Color.darkBlue.withAlphaComponent(0.9)
        textField.text = APIServices.shared.credential.password
        textField.setPlaceholder("Password", with: Color.white.withAlphaComponent(0.3))
        textField.setClearButton(color: Color.white.withAlphaComponent(0.3))
        return textField
    }()

    fileprivate lazy var whatIsButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(Color.lightBlue, for: .normal)
        button.setTitle("What is Earth 2?", for: .normal)
        button.addTarget(self, action:#selector(didPressWhatIsButton), for: .touchUpInside)
        return button
    }()

    fileprivate lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(Color.lightBlue, for: .normal)
        button.setTitle("Create an account", for: .normal)
        button.addTarget(self, action:#selector(didPressCreateAccountButton), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var loadingBanner: LoadingBanner = {
        let view = LoadingBanner()
        view.tintColor = Color.white.withAlphaComponent(0.75)
        return view
    }()

    // IB
    @IBOutlet fileprivate var logoView: UIView!
    @IBOutlet fileprivate var logoImageView: UIImageView!
    @IBOutlet fileprivate var galaxyView: GalaxyView!
    @IBOutlet fileprivate var titleLabel: UILabel!
    @IBOutlet fileprivate var subtitleLabel: UILabel!
    @IBOutlet fileprivate var launchViewCenterYConstraint: NSLayoutConstraint?
    @IBOutlet fileprivate var logoImageViewHeightConstraint: NSLayoutConstraint?

    fileprivate var loginFormViewCenterYConstraint: Constraint?
    fileprivate var verticalOffset: CGFloat = 0

    fileprivate var isKeyboardVisible: Bool = false
    fileprivate var firstTimeLoading: Bool = true

    // API
    fileprivate let authApi = AuthApi()

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
        if true /* APIServices.shared.isLoggedIn */ {
            presentHome(animated: false)
        } else if firstTimeLoading {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2)) {
                self.emailField.becomeFirstResponder()
                self.firstTimeLoading = false
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
        galaxyView.bottomColor = Color.darkBlue

        logoImageView.isUserInteractionEnabled = true
        logoImageView.addGlow(with: UIColor(hex: "00b0f4"), radius: 30, opacity: 0.25)
        view.bringSubviewToFront(logoImageView)

        titleLabel.addCharacterSpacing(kernValue: 13)
        titleLabel.addGlow(with: Color.blue, radius: 3)

        subtitleLabel.addCharacterSpacing(kernValue: 9)
        subtitleLabel.addGlow(with: Color.black, radius: 3)

        loadingBanner.setMessage(StringConstants.nonaffiliate)

        view.addSubview(loadingBanner)
        loadingBanner.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-Constants.padding*6)
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

        loginFormView.addSubview(legendLabel)
        legendLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.padding)
            $0.leading.equalToSuperview().offset(Constants.padding)
            $0.trailing.equalToSuperview().offset(-Constants.padding)
        }

        loginFormView.addSubview(emailField)
        emailField.snp.makeConstraints {
            $0.top.equalTo(legendLabel.snp.bottom).offset(Constants.padding*1.5)
            $0.leading.equalToSuperview().offset(Constants.padding)
            $0.trailing.equalToSuperview().offset(-Constants.padding)
            $0.height.greaterThanOrEqualTo(40)
        }

        loginFormView.addSubview(passwordField)
        passwordField.snp.makeConstraints {
            $0.top.equalTo(emailField.snp.bottom).offset(Constants.padding*1)
            $0.leading.equalToSuperview().offset(Constants.padding)
            $0.trailing.equalToSuperview().offset(-Constants.padding)
            $0.height.greaterThanOrEqualTo(40)
        }

        loginFormView.addSubview(whatIsButton)
        whatIsButton.snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(Constants.padding*2)
            $0.trailing.equalToSuperview().offset(-Constants.padding)
            $0.bottom.equalToSuperview().offset(-Constants.padding)
        }

        loginFormView.addSubview(createAccountButton)
        createAccountButton.snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(Constants.padding*2)
            $0.leading.equalToSuperview().offset(Constants.padding)
            $0.bottom.equalToSuperview().offset(-Constants.padding)
        }
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

    fileprivate func enableLoginForm(_ enable: Bool = true) {
        loginFormView.isUserInteractionEnabled = enable
        loginFormView.alpha = enable ? 1 : 0.75
        emailField.alpha = enable ? 1 : 0.5
        passwordField.alpha = enable ? 1 : 0.5
        createAccountButton.alpha = enable ? 1 : 0.5
    }

    fileprivate func cleanLoginForm() {
        emailField.text = ""
        passwordField.text = ""
    }

    fileprivate func presentHome(animated: Bool = true) {
        let vc = HomeViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: animated, completion: nil)
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
            guard let email = emailField.text else { shakelogoImageView(); return false }
            guard Validator.isEmail().apply(email) else { shakelogoImageView(); return false }
            return true
        }

        func validatePassword() -> Bool {
            guard let password = passwordField.text, !Validator.isEmpty().apply(password) else { shakelogoImageView(); return false }
            return true
        }

        func prepareToSubmit() {
            guard let email = emailField.text, let password = passwordField.text else { return }

            textField.resignFirstResponder()
            loadingBanner.setLoading(true)
            enableLoginForm(false)

            authApi.login(email, password: password) { [weak self] (user, error) in
                if let user = user {
                    self?.loadingBanner.setLoading(false, with: "Welcome back \(user.username)")
                    //self?.presentHome()
                    //self?.cleanLoginForm()
                } else {
                    self?.enableLoginForm(true)

                    if let error = error {
                        self?.loadingBanner.setError(error)
                    } else {
                        self?.loadingBanner.setLoading(false)
                    }
                }
            }
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

    @objc func didPressWhatIsButton() {
        WebViewController.open(.about)
    }

    @objc func didPressCreateAccountButton() {
        WebViewController.open(.login)
    }

    @objc func shakelogoImageView() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.4
        animation.values = [-20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        logoImageView.layer.add(animation, forKey: "shake")
    }

    // MARK: - Actions

    @objc func keyboardWillShow(_ notification: Notification) {
        guard !isKeyboardVisible else { return }
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardRect = keyboardFrame.cgRectValue

        if verticalOffset == 0 {
            verticalOffset = keyboardRect.intersection(loginFormView.frame).height
        }

        let loginFormRect = loginFormView.frame
        let topHeight = loginFormRect.minY - verticalOffset
        let logoExpectedHeight = topHeight/3

        UIView.animate(withDuration: 0, // inherits the animation duration from the keyboard's
                       animations: {
                        self.loginFormViewCenterYConstraint?.update(offset: -self.verticalOffset)

                        // only once
                        if let constraint = self.launchViewCenterYConstraint, constraint.constant == 0 {
                            let centerY = loginFormRect.height + logoExpectedHeight
                            self.launchViewCenterYConstraint?.constant = -centerY
                        }

                        if self.emailField.isFirstResponder {
                            self.logoImageViewHeightConstraint?.constant = logoExpectedHeight
                        }

                        self.loginFormView.alpha = 1
                        self.titleLabel.alpha = 0
                        self.subtitleLabel.alpha = 0

                        self.view.layoutIfNeeded()
        },
                       completion: nil)

        isKeyboardVisible = true
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        guard isKeyboardVisible else { return }

        UIView.animate(withDuration: 0, // inherits the animation duration from the keyboard's
                       animations: {
                        self.loginFormViewCenterYConstraint?.update(offset: 0)
                        self.view.layoutIfNeeded()
        },
                       completion: nil)

        isKeyboardVisible = false
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

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
