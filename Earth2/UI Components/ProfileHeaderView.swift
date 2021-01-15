//
//  ProfileHeaderView.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-14.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {

    // MARK: - Public Variables

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: Constants.height)
    }

    lazy var favoriteButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setImage(UIImage(named: "icn_favorites"), for: .normal)
        button.tintColor = Color.red
        button.hitTestEdgeInsets = UIEdgeInsets(square: -20)
        return button
    }()

    lazy var referralButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.titleLabel?.font = Font.font(ofSize: 17, weight: .medium)
        button.tintColor = Color.white
        button.hitTestEdgeInsets = UIEdgeInsets(square: -20)
        return button
    }()

    lazy var settingsButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setImage(UIImage(named: "icn_settings"), for: .normal)
        button.tintColor = Color.paleBlue
        button.hitTestEdgeInsets = UIEdgeInsets(square: -20)
        return button
    }()

    lazy var legendLabel1: UILabel = {
        let label = UILabel()
        label.font = Font.font(ofSize: 14, weight: .medium)
        label.textColor = Color.paleBlue
        label.textAlignment = .center
        return label
    }()

    lazy var amountLabel1: UILabel = {
        let label = UILabel()
        label.font = Font.font(ofSize: 70, weight: .ultraLight)
        label.textColor = Color.white
        label.textAlignment = .center
        return label
    }()

    lazy var statsLabel1: UILabel = {
        let label = UILabel()
        label.font = Font.font(ofSize: 19, weight: .regular)
        label.textColor = Color.green
        label.textAlignment = .right
        return label
    }()

    lazy var statsLabel2: UILabel = {
        let label = UILabel()
        label.font = Font.font(ofSize: 19, weight: .regular)
        label.textColor = Color.green
        label.textAlignment = .left
        return label
    }()

    lazy var legendLabel2: UILabel = {
        let label = UILabel()
        label.font = Font.font(ofSize: 14, weight: .medium)
        label.textColor = Color.paleBlue
        label.textAlignment = .center
        return label
    }()

    lazy var amountLabel2: UILabel = {
        let label = UILabel()
        label.font = Font.font(ofSize: 70, weight: .ultraLight)
        label.textColor = Color.white
        label.textAlignment = .center
        return label
    }()

    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = Font.font(ofSize: 15, weight: .regular)
        label.textColor = Color.paleBlue.withAlphaComponent(0.5)
        label.textAlignment = .center
        return label
    }()

    // MARK: - Private Variables

    fileprivate lazy var leftButtonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [favoriteButton, referralButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = Constants.padding
        return stackView
    }()

    fileprivate lazy var statsLabelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [statsLabel1, statsLabel2])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = Constants.padding*2
        return stackView
    }()

    fileprivate enum Constants {
        static let padding: CGFloat = UniversalConstants.padding
        static let height: CGFloat = 360
    }

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    fileprivate func setupLayout() {

        let padding = Constants.padding
        backgroundColor = Color.clear

        addSubview(leftButtonsStackView)
        leftButtonsStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(padding/2)
            $0.leading.equalToSuperview().offset(padding)
        }

        addSubview(settingsButton)
        settingsButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(padding/2)
            $0.trailing.equalToSuperview().offset(-padding)
        }

        addSubview(legendLabel1)
        legendLabel1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(padding*4)
            $0.centerX.equalToSuperview()
        }

        addSubview(amountLabel1)
        amountLabel1.snp.makeConstraints {
            $0.top.equalTo(legendLabel1.snp.bottom).offset(-padding/2)
            $0.centerX.equalToSuperview()
        }

        addSubview(statsLabelsStackView)
        statsLabelsStackView.snp.makeConstraints {
            $0.top.equalTo(amountLabel1.snp.bottom).offset(-padding/2)
            $0.centerX.equalToSuperview()
        }

        addSubview(legendLabel2)
        legendLabel2.snp.makeConstraints {
            $0.top.equalTo(statsLabelsStackView.snp.bottom).offset(padding*2)
            $0.centerX.equalToSuperview()
        }

        addSubview(amountLabel2)
        amountLabel2.snp.makeConstraints {
            $0.top.equalTo(legendLabel2.snp.bottom).offset(-padding/2)
            $0.centerX.equalToSuperview()
        }

        addSubview(statusLabel)
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(amountLabel2.snp.bottom).offset(padding/2)
            $0.centerX.equalToSuperview()
        }

        referralButton.setTitle("5KVO65G0HS", for: .normal)
        statusLabel.text = "Last Update 02-01-2021"

        legendLabel1.text = "NET WORTH (US$)"
        amountLabel1.text = "1,564.54"
        statsLabel1.text = "+1,013.52"
        statsLabel2.text = "+183.9%"

        legendLabel2.text = "BALANCE (US$)"
        amountLabel2.text = "53.12"
    }
}
