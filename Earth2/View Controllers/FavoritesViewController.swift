//
//  FavoritesViewController.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-12.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import SnapKit
import E2API

class FavoritesViewController: DarkModalViewController {

    // MARK: - Public Variables

    // MARK: - Private Variables

    lazy var addButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setImage(UIImage(named: "icn_navbar_add"), for: .normal)
        button.tintColor = Color.gray100
        button.hitTestEdgeInsets = UIEdgeInsets(-20, -20, -20, -10)
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
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

    // MARK: - Layout

    fileprivate func setupLayout() {
        title = "Favorites"

        navigationBar.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Constants.padding)
        }
    }

    // MARK: - Actions

    @objc fileprivate func didTapAddButton() {
        print("didTapAddButton")
    }
}
