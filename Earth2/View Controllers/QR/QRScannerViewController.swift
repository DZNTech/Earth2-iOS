//
//  QRScannerViewController.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-27.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import SnapKit
import PanModal
import AVFoundation

protocol QRScannerViewControllerDelegate: class {
    func qrScanningDidFail(_ viewController: QRScannerViewController)
    func qrScanningSucceeded(_ viewController: QRScannerViewController, with string: String)
    func qrScanningDidStop(_ viewController: QRScannerViewController)
}

class QRScannerViewController: UIViewController {

    // MARK: - Public Variables

    weak var delegate: QRScannerViewControllerDelegate?

    override var title: String? {
        didSet {
            titleLabel.text = title?.uppercased()
            titleLabel.addCharacterSpacing(kernValue: 2)
        }
    }

    // MARK: - Private Variables

    lazy var closeButton: CustomButton = {
        let button = CustomButton(type: .system)
        button.setImage(UIImage(named: "icn_navbar_close"), for: .normal)
        button.tintColor = Color.gray200
        button.hitTestEdgeInsets = UIEdgeInsets(-20, -20, -20, -10)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()

    fileprivate lazy var navigationBar: UIView = {
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

    lazy var videoPreview: CaptureVideoPreview = {
        let view = CaptureVideoPreview()
        view.backgroundColor = Color.black
        return view
    }()

    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.font(ofSize: 18, weight: .medium)
        label.textColor = Color.white
        label.textAlignment = .center
        return label
    }()

    fileprivate var captureSession: AVCaptureSession?

    fileprivate enum Constants {
        static let padding: CGFloat = UniversalConstants.padding
    }

    // MARK: - View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupVideoPreview()
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

    fileprivate func setupLayout() {
        title = "Scan QR Code"
        view.backgroundColor = Color.gray500

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(54)
        }

        navigationBar.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-Constants.padding)
        }

        view.addSubview(videoPreview)
        videoPreview.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }

    // MARK: - Actions

    @objc fileprivate func didTapCloseButton() {
        dismiss(animated: true)
    }

    // MARK: - View Control

    func setupVideoPreview() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch let error {
            print(error)
            return
        }

        if (captureSession?.canAddInput(videoInput) ?? false) {
            captureSession?.addInput(videoInput)
        } else {
            scanningDidFail()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession?.canAddOutput(metadataOutput) ?? false) {
            captureSession?.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417]
        } else {
            scanningDidFail()
            return
        }

        videoPreview.layer.session = captureSession
        videoPreview.layer.videoGravity = .resizeAspectFill

        captureSession?.startRunning()
    }

    func startScanning() {
       captureSession?.startRunning()
    }

    func stopScanning() {
        captureSession?.stopRunning()
        delegate?.qrScanningDidStop(self)
    }

    func scanningDidFail() {
        delegate?.qrScanningDidFail(self)
        captureSession = nil
    }

    func didFindCode(_ code: String) {
        delegate?.qrScanningSucceeded(self, with: code)
    }

    var isRunning: Bool {
        return captureSession?.isRunning ?? false
    }
}

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        stopScanning()

        if let metadataObject = metadataObjects.first {
            guard let string = metadataObject.stringFromQR() else { return }
            didFindCode(string)
        }
    }
}

extension QRScannerViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
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

class CaptureVideoPreview: UIView {

    override class var layerClass: AnyClass  {
        return AVCaptureVideoPreviewLayer.self
    }

    override var layer: AVCaptureVideoPreviewLayer {
        return super.layer as! AVCaptureVideoPreviewLayer
    }
}
