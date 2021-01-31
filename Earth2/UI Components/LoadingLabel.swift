//
//  LoadingLabel.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-12.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import SnapKit

class LoadingLabel: UIView {

    // MARK: - Public Methods

    func setLoading(_ loading: Bool = true) {
        setMessage(loading ? "Loading..." : nil)
        activityIndicatorView.animate(loading)
    }

    func setLoading(_ loading: Bool = true, with message: String?) {
        setMessage(message)
        activityIndicatorView.animate(loading)
    }

    func setMessage(_ message: String?) {
        messageLabel.text = message
        messageLabel.isHidden = message == nil
        messageLabel.textColor = tintColor
    }

    func setError(_ error: Error) {
        setMessage(error.localizedDescription)
        messageLabel.textColor = Color.yellow
        activityIndicatorView.animate(false)
    }

    var axis: NSLayoutConstraint.Axis = .vertical {
        didSet {
            stackView.axis = axis
        }
    }

    override var tintColor: UIColor! {
        didSet {
            activityIndicatorView.color = tintColor
            messageLabel.textColor = tintColor
        }
    }

    var textFont: UIFont = UIFont.systemFont(ofSize: 15, weight: .medium) {
        didSet {
            messageLabel.font = textFont
        }
    }

    // MARK: - Private Variables

    fileprivate lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = tintColor
        view.hidesWhenStopped = true
        return view
    }()

    fileprivate lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = textFont
        label.textColor = tintColor
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()

    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [activityIndicatorView, messageLabel])
        stackView.axis = self.axis
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = Constants.padding*3/4
        return stackView
    }()

    fileprivate enum Constants {
        static let padding: CGFloat = UniversalConstants.padding
    }

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Layout

    fileprivate func setupLayout() {

        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
    }
}


