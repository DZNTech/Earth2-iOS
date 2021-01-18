//
//  FormTableViewCell.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-17.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

class FormTableViewCell: UITableViewCell {

    // MARK: - Public Variables

    var isLoading: Bool = false {
        didSet {
            if isLoading {
                accessoryView = spinnerView
                spinnerView.startAnimating()
            } else {
                accessoryView = nil
                accessoryType = .disclosureIndicator
            }
        }
    }

    // MARK: - Private Variables

    fileprivate lazy var spinnerView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = tintColor
        return view
    }()

    fileprivate enum Constants {
        static let padding: CGFloat = UniversalConstants.padding
    }

    // MARK: - Initializatiom

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    fileprivate func setupLayout() {
        self.tintColor = Color.white
        self.backgroundColor = UIColor(hex: "353537").withAlphaComponent(0.5)
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = Color.black.withAlphaComponent(0.125)
        self.selectedBackgroundView = selectedBackgroundView

        textLabel?.font = Font.font(ofSize: 17, weight: .medium)

        accessoryType = .disclosureIndicator
    }
}


