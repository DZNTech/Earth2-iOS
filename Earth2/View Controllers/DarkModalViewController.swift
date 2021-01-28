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

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.tableFooterView = UIView()
        tableView.separatorColor = Color.gray300.withAlphaComponent(0.4)
        tableView.separatorInset = .zero
        tableView.backgroundColor = Color.clear
        return tableView
    }()

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

        navigationBar.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        return navigationBar
    }()

    var presentationState: PanModalPresentationController.PresentationState = .shortForm

    override var title: String? {
        didSet {
            titleLabel.text = title?.uppercased()
            titleLabel.addCharacterSpacing(kernValue: 2)
        }
    }

    // MARK: - Private Variables

    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
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
        setupLayout()
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

    open func setupLayout() {
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

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Actions

    func willTransitionToPresentationState(_ state: PanModalPresentationController.PresentationState) {
        presentationState = state
        tableView.reloadEmptyDataSet()
    }
}

extension DarkModalViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return tableView
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(view.bounds.height/2)
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

    func willTransition(to state: PanModalPresentationController.PresentationState) {
        willTransitionToPresentationState(state)
    }
}
