//
//  ProfileHeaderView.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-14.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import UICountingLabel

class ProfileHeaderView: UIView {

    // MARK: - Public Variables

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: Constants.height)
    }

    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .top
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var favoriteButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setImage(UIImage(named: "icn_favorites"), for: .normal)
        button.tintColor = Color.red
        button.hitTestEdgeInsets = UIEdgeInsets(-20, -20, -20, -10)
        return button
    }()

    lazy var referralButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.titleLabel?.font = Font.font(ofSize: 17, weight: .semibold)
        button.tintColor = Color.white
        button.hitTestEdgeInsets = UIEdgeInsets(-20, -10, -20, -20)
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

    lazy var amountLabel1: UICountingLabel = {
        let label = UICountingLabel()
        label.font = Font.font(ofSize: 70, weight: .ultraLight)
        label.textColor = Color.white
        label.textAlignment = .center
        return label
    }()

    lazy var statsLabel1: UICountingLabel = {
        let label = UICountingLabel()
        label.font = Font.font(ofSize: 19, weight: .regular)
        label.textColor = Color.green
        label.textAlignment = .right
        return label
    }()

    lazy var statsLabel2: UICountingLabel = {
        let label = UICountingLabel()
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

    lazy var amountLabel2: UICountingLabel = {
        let label = UICountingLabel()
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

    fileprivate lazy var leftButtonsStackView: CustomStackView = {
        let stackView = CustomStackView(arrangedSubviews: [favoriteButton, referralButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = Constants.padding
        stackView.hitTestEdgeInsets = UIEdgeInsets(square: -20)
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

    fileprivate lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = Color.blue
        return view
    }()

    fileprivate enum Constants {
        static let padding: CGFloat = UniversalConstants.padding
        static let height: CGFloat = 380
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

        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(-UIApplication.shared.statusBarFrame.height)
        }

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

        addSubview(separatorLine)
        separatorLine.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }

        statusLabel.text = "Last Update 02-01-2021"

        legendLabel1.text = "NET WORTH (US$)"
        legendLabel2.text = "BALANCE (US$)"
    }
}

extension UICountingLabel {

    func setCount(_ count: Float, format: String = "%@", animated: Bool = true) {
        method = .easeIn
        formatBlock = { (value) -> String? in
            if let string = UICountingLabel.amountFormatter.string(from: value as NSNumber) {
                return NSString(format: (format as NSString), string) as String
            }
            return ""
        }

        let duration: TimeInterval = animated ? 1.5 : 0
        countFromZero(to: CGFloat(count), withDuration: duration)
    }

    fileprivate static var amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
