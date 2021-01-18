//
//  ReferralController.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-18.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import Foundation
import LinkPresentation
import E2API

class ReferralController: NSObject {

    convenience init(user: User) {
        self.init(username: user.username, referralCode: user.referralCode)
    }

    init(username: String, referralCode: String) {
        self.username = username
        self.referralCode = referralCode
    }

    func showActivityController(_ from: UIViewController) {
        DispatchQueue.main.async {
            guard let qrImage = QRCode.e2QRImage(with: self.username, referralCode: self.referralCode) else { return }
            guard let imageURL = qrImage.save(with: self.referralCode) else { return }

            self.qrImageURL = imageURL

            // Copy code as text or image
            let copyStringActivity = CopyItemActivity(with: .copyCode)
            let copyImageActivity = CopyItemActivity(with: .copyImage)

            let activityVC = UIActivityViewController(activityItems: [self], applicationActivities: [copyStringActivity, copyImageActivity])
            activityVC.excludedActivityTypes = [.assignToContact, .addToReadingList, .openInIBooks, .markupAsPDF, .copyToPasteboard]
            activityVC.overrideUserInterfaceStyle = .dark
            from.present(activityVC, animated: true)
        }
    }

    fileprivate var qrImageURL: URL?
    fileprivate let username: String
    fileprivate let referralCode: String
}

extension ReferralController: UIActivityItemSource {

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return UIImage()
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        if activityType == .copyCode {
            if let user = APIServices.shared.myUser {
                return user.referralCode
            }
        }

        return qrImageURL
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        guard let user = APIServices.shared.myUser else { return nil }

        let metadata = LPLinkMetadata()
        metadata.title = user.referralCode
        metadata.originalURL = qrImageURL // determines the Preview Subtitle
        metadata.imageProvider = NSItemProvider.init(contentsOf: qrImageURL)
        return metadata
    }
}

