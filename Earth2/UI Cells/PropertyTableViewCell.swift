//
//  PropertyTableViewCell.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-12.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import SnapKit

class PropertyTableViewCell: UITableViewCell {

    // MARK: - Public Variables

    var isOdd: Bool = false {
        didSet {
            if isOdd {
                backgroundColor = .clear
            } else {
                backgroundColor = Color.white.withAlphaComponent(0.025)
            }
        }
    }

    lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Color.white
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.font(ofSize: 17, weight: .medium)
        label.textColor = Color.white
        return label
    }()

    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.font(ofSize: 15, weight: .regular)
        label.textColor = Color.gray20
        return label
    }()

    lazy var profitLabel: UILabel = {
        let label = UILabel()
        label.font = Font.font(ofSize: 15, weight: .regular)
        label.textColor = Color.white
        label.textAlignment = .right
        return label
    }()

    lazy var tileLabel: UILabel = {
        let label = UILabel()
        label.font = Font.font(ofSize: 15, weight: .regular)
        label.textColor = Color.white
        label.textAlignment = .right
        return label
    }()

    // MARK: - Private Variables

    fileprivate lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = 5
        return stackView
    }()

    fileprivate lazy var profitStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profitLabel, tileLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .trailing
        stackView.spacing = 5
        return stackView
    }()

    fileprivate enum Constants {
        static let padding: CGFloat = UniversalConstants.padding
        static let imageHeight: CGFloat = UniversalConstants.cellThumbHeight
    }

    // MARK: - Initializatiom

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    fileprivate func setupLayout() {

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = Color.darkerBlue.withAlphaComponent(0.5)
        self.selectedBackgroundView = selectedBackgroundView

        accessoryType = .disclosureIndicator

        contentView.addSubview(thumbImageView)
        thumbImageView.snp.makeConstraints {
            $0.height.width.equalTo(Constants.imageHeight)
            $0.leading.equalToSuperview().offset(Constants.padding)
            $0.centerY.equalToSuperview()
        }

        contentView.addSubview(profitStackView)
        profitStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-Constants.padding)
            $0.centerY.equalToSuperview()
        }

        contentView.addSubview(labelStackView)
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(thumbImageView.snp.trailing).offset(Constants.padding)
            $0.trailing.equalTo(profitStackView.snp.leading).offset(-Constants.padding)
            $0.centerY.equalToSuperview()
        }
    }
}
