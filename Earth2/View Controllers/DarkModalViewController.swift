//
//  DarkModalViewController.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-17.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import SnapKit
import PanModal

class DarkModalViewController: UIViewController {

    // MARK: - Public Variables

    lazy var navigationBar: UIView = {
        let navigationBar = UIView()
        navigationBar.backgroundColor = Color.clear

        let separatorLine = UIView()
        separatorLine.backgroundColor = Color.gray300.withAlphaComponent(0.4)
        navigationBar.addSubview(separatorLine)
        separatorLine.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }

        return navigationBar
    }()

    override var title: String? {
        didSet {
            titleLabel.text = title?.uppercased()
            titleLabel.addCharacterSpacing(kernValue: 2)
        }
    }

    // MARK: - Private Variables

    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "titleLabel"
        label.font = Font.font(ofSize: 18, weight: .medium)
        label.textColor = Color.white
        label.textAlignment = .center
        return label
    }()

    fileprivate enum Constants {
        static let padding: CGFloat = UniversalConstants.padding
    }

    // MARK: - View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        _setupLayout()
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

    fileprivate func _setupLayout() {
        view.backgroundColor = Color.gray500

        let backgroundView = UIView()
        backgroundView.backgroundColor = Color.gray500
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(54)
        }

        navigationBar.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}

extension DarkModalViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(view.bounds.width)
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
