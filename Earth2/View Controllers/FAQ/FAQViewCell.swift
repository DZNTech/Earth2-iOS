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

    var questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    var answerTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.clear
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.isEditable = false
        textView.dataDetectorTypes = []
        return textView
    }()

    var indicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var answerTextViewBottom = NSLayoutConstraint()

    var configuration: FAQConfiguration? {
        didSet {
            setup(with: configuration)
        }
    }

    var didSelectQuestion: ((_ cell: FAQViewCell) ->())?

    // MARK: Private

    private let actionByQuestionTap = #selector(didTapQuestion)

    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        viewSetup()
    }

    fileprivate func viewSetup() {
        selectionSetup()
        self.containerView.addSubview(indicatorImageView)
        contentView.addSubview(questionLabel)
        contentView.addSubview(answerTextView)
        contentView.addSubview(containerView)
        addLabelConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(currentItem: FAQItem, indexPath: IndexPath, cellOperation: FAQCellOperation) {
        questionLabel.text = currentItem.question

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

    // MARK: Private Methods

    fileprivate func selectionSetup() {
        questionLabel.isUserInteractionEnabled = true
        indicatorImageView.isUserInteractionEnabled = true

        let questionLabelGestureRecognizer = UITapGestureRecognizer(target: self, action : actionByQuestionTap)
        questionLabel.addGestureRecognizer(questionLabelGestureRecognizer)

        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: actionByQuestionTap)
        indicatorImageView.addGestureRecognizer(imageGestureRecognizer)
    }

    fileprivate func setup(with configuration: FAQConfiguration?) {

        backgroundColor = configuration?.cellBackgroundColor
        questionLabel.textColor = configuration?.questionTextColor
        answerTextView.textColor = configuration?.answerTextColor
        questionLabel.font = configuration?.questionTextFont
        answerTextView.font = configuration?.answerTextFont

        if let textColor = configuration?.questionTextColor {
            indicatorImageView.image = UIImage(named: "icn_arrow_down")?.withTintColor(textColor)
        }

        if let dataDetectorTypes = configuration?.dataDetectorTypes {
            answerTextView.dataDetectorTypes = dataDetectorTypes
        }

        if let tintColor = configuration?.tintColor {
            answerTextView.tintColor = tintColor
        }
    }

    fileprivate func addLabelConstraints() {
        let questionLabelTrailing = NSLayoutConstraint(item: questionLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailingMargin, multiplier: 1, constant: -30)
        let questionLabelLeading = NSLayoutConstraint(item: questionLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leadingMargin, multiplier: 1, constant: 0)
        let questionLabelTop = NSLayoutConstraint(item: questionLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 10)

        let answerTextViewTrailing = NSLayoutConstraint(item: answerTextView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailingMargin, multiplier: 1, constant: -30)
        let answerTextViewLeading = NSLayoutConstraint(item: answerTextView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leadingMargin, multiplier: 1, constant: -5)
        let answerTextViewTop = NSLayoutConstraint(item: answerTextView, attribute: .top, relatedBy: .equal, toItem: questionLabel, attribute: .bottom, multiplier: 1, constant: 10)
        answerTextViewBottom = NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: answerTextView, attribute: .bottom, multiplier: 1, constant: 0)

        let indicatorHorizontalCenter = NSLayoutConstraint(item: indicatorImageView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0)
        let indicatorVerticalCenter = NSLayoutConstraint(item: indicatorImageView, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0)
//        let indicatorWidth = NSLayoutConstraint(item: indicatorImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
//        let indicatorHeight = NSLayoutConstraint(item: indicatorImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)

        let containerTrailing = NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailingMargin, multiplier: 1, constant: 5)
        let containerWidth = NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        let containerTop = NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: contentView,attribute: .top, multiplier: 1, constant: 10)
        let containerHeight = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: questionLabel, attribute: .height, multiplier: 1, constant: 0)

        NSLayoutConstraint.activate([questionLabelTrailing, questionLabelLeading, questionLabelTop, answerTextViewLeading
          , answerTextViewTrailing, answerTextViewTop ,answerTextViewBottom, indicatorVerticalCenter, indicatorHorizontalCenter, containerTrailing, containerTop, containerWidth, containerHeight])
    }

    @objc fileprivate func didTapQuestion(_ recognizer: UIGestureRecognizer) {
        didSelectQuestion?(self)
    }

    fileprivate func expand(withAnswer answer: String, animated: Bool) {
        answerTextView.text = answer
        expand(animated: animated)
    }

    fileprivate func expand(withAttributedAnswer attributedAnswer: NSAttributedString, animated: Bool) {
        answerTextView.attributedText = attributedAnswer
        expand(animated: animated)
    }

    fileprivate func expand(animated: Bool) {
        answerTextView.isHidden = false

        if animated {
            answerTextView.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
              self.answerTextView.alpha = 1
            })
        }

        answerTextViewBottom.constant = 20
        update(arrow: .up, animated: animated)
    }

    fileprivate func collapse(animated: Bool) {
        answerTextView.text = ""
        answerTextView.isHidden = true
        answerTextViewBottom.constant = -20
        update(arrow: .down, animated: animated)
    }

    fileprivate func update(arrow: FAQViewCellArrow, animated: Bool) {
        switch arrow {
        case .up:
            if animated {
                // Change direction from down to up with animation
                indicatorImageView.rotate(withAngle: CGFloat(0), animated: false)
                indicatorImageView.rotate(withAngle: CGFloat(Double.pi), animated: true)
            } else {
                // Change direction from down to up without animation
                indicatorImageView.rotate(withAngle: CGFloat(Double.pi), animated: false)
            }
        case .down:
            if animated {
                // Change direction from up to down with animation
                indicatorImageView.rotate(withAngle: CGFloat(Double.pi), animated: false)
                indicatorImageView.rotate(withAngle: CGFloat(0), animated: true)
            } else {
                // Change direction from up to down without animation
                indicatorImageView.rotate(withAngle: CGFloat(0), animated: false)
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
