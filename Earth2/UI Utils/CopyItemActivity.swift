//
//  CopyItemActivity.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-16.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

extension UIActivity.ActivityType {
    public static let copyCode = UIActivity.ActivityType(rawValue: "copy_code")
    public static let copyImage = UIActivity.ActivityType(rawValue: "copy_image")
}

class CopyItemActivity: UIActivity {

    override var activityTitle: String? {
        if activityType == .copyCode {
            return "Copy Code"
        } else if activityType == .copyImage {
            return "Copy Image"
        } else {
            return nil
        }
    }

    override var activityImage: UIImage? {
        return UIImage(named: "icn_activity_copy_item")
    }

    override var activityType: UIActivity.ActivityType? {
        return _type
    }

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for item in activityItems {
            if item is String || item is UIImage {
                return true
            }
        }
        return false
    }

    override func prepare(withActivityItems activityItems: [Any]) {
        for item in activityItems {
            if let string = item as? String {
                _string = string
            } else if let image = item as? UIImage {
                _image = image
            }
        }
    }

    override func perform() {
        if let string = _string {
            UIPasteboard.general.string = string
        } else if let image = _image {
            UIPasteboard.general.image = image
        }

        activityDidFinish(true)
    }

    fileprivate var _type : UIActivity.ActivityType
    fileprivate var _string : String? = nil
    fileprivate var _image : UIImage? = nil

    public init(with type: UIActivity.ActivityType) {
        _type = type
    }
}
