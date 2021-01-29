//
//  FAQViewCellTableViewCell.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-28.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import SnapKit

class FAQViewCell: UITableViewCell {

    // MARK: Public

    var configuration: FAQConfiguration? {
        didSet {
            setup(with: configuration)
        }
    }

    var didSelectQuestion: ((_ cell: FAQViewCell) ->())?

    // MARK: Private

    fileprivate var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        return label
    }()

    fileprivate var button: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        return button
    }()

    fileprivate var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = Color.clear
        textView.textContainerInset = .zero
        textView.dataDetectorTypes = []
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = [.link]
        return textView
    }()

    fileprivate var indicatorView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    fileprivate var textViewBottom = NSLayoutConstraint()
    fileprivate var textViewBottomConstraint: Constraint?

    // MARK: - Initializatiom

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Layout

    fileprivate func setupLayout() {

        let labelGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapQuestion))
        label.addGestureRecognizer(labelGestureRecognizer)

        let viewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapQuestion))
        indicatorView.addGestureRecognizer(viewGestureRecognizer)

        if true {
            contentView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false

            contentView.addSubview(textView)
            textView.translatesAutoresizingMaskIntoConstraints = false

            contentView.addSubview(indicatorView)
            indicatorView.translatesAutoresizingMaskIntoConstraints = false

            setupConstraints()
        } else {
//            let containerView = UIView()
//            containerView.backgroundColor = .red
//            contentView.addSubview(containerView)
//            containerView.snp.makeConstraints {
//                $0.trailing.equalToSuperview().offset(-20)
//                $0.leading.equalToSuperview().offset(20)
//                $0.top.bottom.equalToSuperview()
//            }

            contentView.addSubview(label)
            label.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-48)
                $0.leading.equalToSuperview().offset(24)
                $0.top.equalToSuperview().offset(12)
            }

            contentView.addSubview(textView)
            textView.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-48)
                $0.leading.equalToSuperview().offset(24)
                $0.top.equalTo(label.snp.bottom).offset(12)
            }

            contentView.addSubview(indicatorView)
            indicatorView.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-15)
                $0.top.equalTo(label.snp.top)
            }

            contentView.snp.makeConstraints {
                textViewBottomConstraint = $0.bottom.equalTo(textView.snp.bottom).constraint
                textViewBottomConstraint?.activate()
            }
        }
    }

    fileprivate func setup(with configuration: FAQConfiguration?) {
        backgroundColor = Color.clear

        label.font = configuration?.questionTextFont
        label.textColor = configuration?.questionTextColor

        textView.textColor = configuration?.answerTextColor
        textView.font = configuration?.answerTextFont

        if let textColor = configuration?.questionTextColor {
            indicatorView.image = UIImage(named: "icn_arrow_down")?.withTintColor(textColor)
        }

        if let tintColor = configuration?.tintColor {
            textView.tintColor = tintColor
        }
    }

    fileprivate func setupConstraints() {

        // TODO: Refactor this mess!

        var constraints = [NSLayoutConstraint]()

        constraints += [NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailingMargin, multiplier: 1, constant: -24)]
        constraints += [NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leadingMargin, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 12)]

        constraints += [NSLayoutConstraint(item: textView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailingMargin, multiplier: 1, constant: -24)]
        constraints += [NSLayoutConstraint(item: textView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leadingMargin, multiplier: 1, constant: -5)]
        constraints += [NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1, constant: 12)]

        constraints += [NSLayoutConstraint(item: indicatorView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailingMargin, multiplier: 1, constant: 5)]
        constraints += [NSLayoutConstraint(item: indicatorView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24)]
        constraints += [NSLayoutConstraint(item: indicatorView, attribute: .top, relatedBy: .equal, toItem: label, attribute: .top, multiplier: 1, constant: 3)]

        textViewBottom = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: textView, attribute: .bottom, multiplier: 1, constant: 0)
        constraints += [textViewBottom]

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: External Configuration

    func configure(currentItem: FAQItem, indexPath: IndexPath, cellOperation: FAQCellOperation) {

        label.text = currentItem.question

        switch cellOperation {
        case .collapsed:
            collapse(animated: false)
        case .expand:
            if let answer = currentItem.answer {
                expand(withAnswer: answer, animated: true)
            } else if let attributedAnswer = currentItem.attributedAnswer {
                expand(withAttributedAnswer: attributedAnswer, animated: true)
            }
        case .collapse:
            collapse(animated: true)
        case .expanded:
            if let answer = currentItem.answer {
                expand(withAnswer: answer, animated: false)
            } else if let attributedAnswer = currentItem.attributedAnswer {
                expand(withAttributedAnswer: attributedAnswer, animated: false)
            }
        }
    }

    // MARK: Actions

    @objc fileprivate func didTapQuestion(_ recognizer: UIGestureRecognizer) {
        didSelectQuestion?(self)
    }

    fileprivate func expand(withAnswer answer: String, animated: Bool) {
        textView.text = answer
        expand(animated: animated)
    }

    fileprivate func expand(withAttributedAnswer attributedAnswer: NSAttributedString, animated: Bool) {
        textView.attributedText = attributedAnswer
        expand(animated: animated)
    }

    fileprivate func expand(animated: Bool) {
        textView.isHidden = false

        if animated {
            textView.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
              self.textView.alpha = 1
            })
        }

        textViewBottom.constant = 12
        textViewBottomConstraint?.update(offset: 12)

        update(arrow: .up, animated: animated)
    }

    fileprivate func collapse(animated: Bool) {
        textView.text = ""
        textView.isHidden = true

        textViewBottom.constant = -12
        textViewBottomConstraint?.update(offset: -12)

        update(arrow: .down, animated: animated)
    }

    fileprivate func update(arrow: FAQViewCellArrow, animated: Bool) {
        switch arrow {
        case .up:
            if animated {
                // Change direction from down to up with animation
                indicatorView.rotate(withAngle: CGFloat(0), animated: false)
                indicatorView.rotate(withAngle: CGFloat(Double.pi), animated: true)
            } else {
                // Change direction from down to up without animation
                indicatorView.rotate(withAngle: CGFloat(Double.pi), animated: false)
            }
        case .down:
            if animated {
                // Change direction from up to down with animation
                indicatorView.rotate(withAngle: CGFloat(Double.pi), animated: false)
                indicatorView.rotate(withAngle: CGFloat(0), animated: true)
            } else {
                // Change direction from up to down without animation
                indicatorView.rotate(withAngle: CGFloat(0), animated: false)
            }
        }
    }
}

fileprivate extension UIImageView {
    func rotate(withAngle angle: CGFloat, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.5 : 0, animations: {
            self.transform = CGAffineTransform(rotationAngle: angle)
        })
    }
}
