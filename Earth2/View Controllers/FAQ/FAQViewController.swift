//
//  FAQViewController.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-28.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import PanModal
import E2API

class FAQViewController: UIViewController {

    // MARK: - Public Variables

    override var title: String? {
        didSet {
            titleLabel.text = title?.uppercased()
            titleLabel.addCharacterSpacing(kernValue: 2)
        }
    }

    // MARK: - Private Variables

    lazy var closeButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setImage(UIImage(named: "icn_navbar_close"), for: .normal)
        button.tintColor = Color.gray200
        button.hitTestEdgeInsets = UIEdgeInsets(-20, -20, -20, -10)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()

    fileprivate lazy var navigationBar: UIView = {
        let navigationBar = UIView()
        navigationBar.backgroundColor = Color.clear

        let separatorLine = UIView()
        separatorLine.backgroundColor = Color.gray300.withAlphaComponent(0.4)
        navigationBar.addSubview(separatorLine)
        separatorLine.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }

        navigationBar.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        return navigationBar
    }()

    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.font(ofSize: 18, weight: .medium)
        label.textColor = Color.white
        label.textAlignment = .center
        return label
    }()

    fileprivate lazy var faqView: FAQView = {
        let view = FAQView(items: faqItems)

        view.questionTextFont = Font.font(ofSize: 17, weight: .regular)
        view.questionTextColor = Color.gray200

        view.answerTextFont = Font.font(ofSize: 17, weight: .regular)
        view.answerTextColor = Color.white

        // Set color for links and detected data
        view.tintColor = Color.paleBlue

        return view
    }()

    fileprivate lazy var faqItems: [FAQItem] = {
        var items = [FAQItem]()

        items += [FAQItem(question: "What is this app about?", answer: "The goal with this app is to give you a quick access to monitor your progression in the game and interact with the E2 platform in a different way.")]
        items += [FAQItem(question: "Is this the offical Earth 2 app?", answer: "No, it is not! This is a fan app for the fast growing E2 community. \(StringConstants.nonaffiliateDiscLong).")]
        items += [FAQItem(question: "Can I purchase and/or sell properties in the app?", answer: "No, sorry. This app is not meant to replace E2's platform but to enhance your gaming experience. Due to technical limitations, we are currently unable to display the E2 map nor implement any transactional features.")]
        items += [FAQItem(question: "Can I browse the market place?", answer: "Not at this time. We may integrate that feature and similar listing of data in a near future.")]
        items += [FAQItem(question: "How does this app connect to earth2.io?", answer: "We hosted a proxy server that connects to earth2.io on your behalf, which then extracts visible information from the website such as your user profile and property list. This is typically called \"web scraping\" and is a read-only task. For this reason, features in this app are limited to what is visible on the website. You should know that \"web scraping\" is fragile and if the E2 developers changed things on the website, this app may malfunction.")]
        items += [FAQItem(question: "Why is the app slow to login to earth2.io?", answer: "During the beta phase, the proxy server in use is not the fastest (free tier). We may upgrade to a faster server once the application is released on the App Store and based on the traffic load.")]
        items += [FAQItem(question: "Are my E2 credentials being stored or logged?", answer: "The proxy server is stateless. What does this mean? No information is being tracked, stored nor logged in the server. \(StringConstants.credentialSavingDisc). You can disable this feature from within the application settings.")]
        items += [FAQItem(question: "Is my E2 data stored or logged?", answer: "The proxy server is stateless. What does this mean? No information is being tracked, stored nor logged in the server. \(StringConstants.dataSavingDisc). You can disable this feature from within the application settings.")]
        items += [FAQItem(question: "How do I send you feedback or questions?", answer: "You can send us bug reports, ideas or questions about the app using this form: \(WebConstant.feebackShort.rawValue). This form is also available from within the application settings.")]
        items += [FAQItem(question: "Can I share this beta app with a friend?", answer: "You can invite your friends to test the beta by sharing this link with them: \(WebConstant.testFlight.rawValue)")]
        items += [FAQItem(question: "Is the source code of this app available?", answer: "Soon! We will open source this application's source code on Github in order to give full transparency on how things work internally. This will be particularly useful if you are familiar with Apple's Swift programming and want to contribute to improve this app.")]
        items += [FAQItem(question: "Who created this app and why?", answer: "Hi, my name is Ignacio and I live in 🇨🇦. I'm a UI/UX designer and iOS 📱 developer with 10+ years of experience. I built this app for fun, as a side project, and for the fast growing E2 community. Want to know more about me?\nLet's connect on LinkedIn: \(WebConstant.linkedIn.rawValue)")]
        return items
    }()

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
        title = "About \(Bundle.main.applicationName)"
        view.backgroundColor = Color.gray500

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(54)
        }

        navigationBar.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-Constants.padding)
        }

        view.addSubview(faqView)
        faqView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }

    // MARK: - Actions

    @objc fileprivate func didTapCloseButton() {
        dismiss(animated: true)
    }
}

extension FAQViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return faqView.tableView
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(view.bounds.height-topOffset)
    }

    var panModalBackgroundColor: UIColor {
        return UIColor(white: 0, alpha: 0.2)
    }

    var dragIndicatorBackgroundColor: UIColor {
        return Color.gray300.withAlphaComponent(0.7)
    }
}
