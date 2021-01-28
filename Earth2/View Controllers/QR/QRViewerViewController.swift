//
//  QRViewerViewController.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-15.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import SnapKit
import PanModal

class QRViewerViewController: UIViewController {

    // MARK: - Private Variables

    fileprivate lazy var qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Color.white
        imageView.contentMode = .center
        imageView.layer.cornerRadius = Constants.imageViewSize.width/Constants.padding
        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImageView)))
        return imageView
    }()

    fileprivate lazy var qrCodeLabel: PasteboardLabel = {
        let label = PasteboardLabel()
        label.font = Font.font(ofSize: 24, weight: .regular)
        label.textColor = Color.white
        label.textAlignment = .center
        return label
    }()

    fileprivate lazy var photosButton: UIButton = {
        let image = UIImage(named: "icn_apple_photos")?.withRenderingMode(.alwaysOriginal)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.setTitle("Save to Photos", for: .normal)
        button.addTarget(self, action: #selector(didPressPhotosButton), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        button.tintColor = Color.black
        button.backgroundColor = Color.white
        button.imageEdgeInsets = UIEdgeInsets(left: -50)
        button.titleEdgeInsets = UIEdgeInsets(left: -30)
        button.layer.cornerRadius = Constants.padding
        button.layer.masksToBounds = true
        return button
    }()

    fileprivate lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: actionButtons())
        stackView.backgroundColor = Color.clear
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = Constants.padding
        return stackView
    }()

    fileprivate func actionButtons() -> [UIView] {
        var subviews = [UIView]()
        subviews += [photosButton]
        return subviews
    }

    fileprivate lazy var QR: QRCode? = {
        var object = QRCode(with: string)
        object?.size = Constants.qrSize
        object?.color = CIColor(color: UIColor.randomColor(seed: string))
        object?.backgroundColor = CIColor(color: Color.white)
        return object
    }()

    fileprivate lazy var backgroundView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemThickMaterial)
        let view = UIVisualEffectView(effect: effect)
        return view
    }()

    fileprivate let string: String

    fileprivate enum Constants {
        static let padding: CGFloat = UniversalConstants.padding
        static let qrSize: CGSize = CGSize(square: 220)
        static let imageViewSize: CGSize = CGSize(square: qrSize.width+20)
        static let buttonHeight: CGFloat = 56
    }

    // MARK: - Initialization

    init(with string: String) {
        self.string = string
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Layout

    fileprivate func setupLayout() {

        view.backgroundColor = Color.white
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView)))

        qrImageView.image = QR?.image(with: UIImage(named: "e2_qr_watermark"))
        qrCodeLabel.text = string

        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }

        view.addSubview(qrCodeLabel)
        qrCodeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(Constants.padding*1.5)
        }

        view.addSubview(qrImageView)
        qrImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(qrCodeLabel.snp.bottom).offset(Constants.padding*1.5)
            $0.size.equalTo(Constants.imageViewSize)
        }

//        view.addSubview(buttonStackView)
//        buttonStackView.snp.makeConstraints {
//            $0.top.equalTo(qrImageView.snp.bottom).offset(Constants.padding*3)
//            $0.centerX.equalToSuperview()
//            $0.width.equalTo(Constants.imageViewSize.width)
//            $0.height.greaterThanOrEqualTo(Constants.buttonHeight)
//        }
//
//        photosButton.snp.makeConstraints {
//            $0.width.equalTo(Constants.imageViewSize.width)
//            $0.height.equalTo(Constants.buttonHeight)
//        }
    }

    // MARK: - Actions

    @objc fileprivate func didTapView() {
        dismiss(animated: true)
    }

    @objc fileprivate func didTapImageView() {
        dismiss(animated: true)
    }

    @objc fileprivate func didPressPhotosButton() {
        guard let image = qrImageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    fileprivate func shareItem(_ item: Any) {
        guard let topMostVC = UIViewController.topMostViewController() else { return }

        let activityVC = UIActivityViewController(activityItems: [item], applicationActivities: [UIActivity]())
        topMostVC.present(activityVC, animated: true)
    }

    @objc fileprivate func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
//        if let error = error {
//            AlertUtil.presentAlertMessage(error.localizedDescription, title: "Save error")
//        } else {
//            AlertUtil.presentAlertMessage("Your MultiGP QR code has been saved to the Photos app!", title: "Saved Image")
//        }
    }
}

extension QRViewerViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(view.bounds.width)
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(view.bounds.width)
    }

    var panModalBackgroundColor: UIColor {
        return UIColor(white: 0.03, alpha: 0.8)
    }

    var dragIndicatorBackgroundColor: UIColor {
        return Color.gray300.withAlphaComponent(0.7)
    }
}
