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

        // View background color
        view.viewBackgroundColor = Color.clear
        view.cellBackgroundColor = Color.clear
        view.separatorColor = Color.clear

        // Set up data detectors for automatic detection of links, phone numbers, etc., contained within the answer text.
        view.dataDetectorTypes = [.link]

        // Set color for links and detected data
        view.tintColor = Color.paleBlue

        return view
    }()

    fileprivate lazy var faqItems: [FAQItem] = {
        var items = [FAQItem]()

        items += [FAQItem(question: "What is this app about?", answer: "Introducing a simple yet beautiful companion app for Earth 2 users. The goal is to give you quick access to monitor your progression in the game and interact with the E2 platform in different ways.")]
        items += [FAQItem(question: "Is this the offical Earth 2 app?", answer: "No, it is not! This is a fan app for the fast growing E2 community. \(StringConstants.nonaffiliateDiscLong).")]
        items += [FAQItem(question: "How does this app connect to earth2.io?", answer: "We hosted a proxy server that connects to earth2.io on your behalf, to then extract information visible on the website such as your user profile and property list. This is typically called \"web scraping\" and is read-only. For this same reason, features are limited to what is visible on the website. You should know that \"web scraping\" is fragile and if the E2 developers changed things on the website, this app may break.")]
        items += [FAQItem(question: "Are my E2 credentials being stored or logged?", answer: "The proxy server is stateless. What does this mean? No information is being tracked, stored nor logged from and to the server. \(StringConstants.credentialSavingDisc). You can disable this feature from within the application settings.")]
        items += [FAQItem(question: "Is my E2 data stored or logged?", answer: "The proxy server is stateless. What does this mean? No information is being tracked, stored nor logged from and to the server. \(StringConstants.dataSavingDisc). You can disable this feature from within the application settings.")]
        items += [FAQItem(question: "Is the source code of this app available?", answer: "Yes! We open sourced this application's source code on Github in order to give full transparency on how things are done. This is particularly useful if you are familiar with programming.\nCheck it out at \(WebConstant.sourceCode.rawValue)")]
        items += [FAQItem(question: "Who created this app and why?", answer: "Hi, my name is Ignacio Romero. I'm a UI designer and iOS developer with 10+ years of experience. I built this app for fun as a side project, for the fast growing E2 community. Want to know more about me?\nLet's connect on LinkedIn \(WebConstant.linkedIn.rawValue)")]
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
