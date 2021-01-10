//
//  UITextField+Extensions.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-10.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

extension UITextField {

    func setPlaceholder(_ placeholder: String, with color: UIColor) {
        let attributes = [NSAttributedString.Key.foregroundColor: color]
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
    }

    func setClearButton(color: UIColor) {
        ClearButtonImage.getImage { [weak self] image in
            guard let image = image, let button = self?.getClearButton() else { return }
            button.imageView?.tintColor = color
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
}

fileprivate extension UITextField {
    func getClearButton() -> UIButton? { return value(forKey: "clearButton") as? UIButton }
}

fileprivate class ClearButtonImage {
    static private var _image: UIImage?
    static private var semaphore = DispatchSemaphore(value: 1)
    static func getImage(closure: @escaping (UIImage?)->()) {
        DispatchQueue.global(qos: .userInteractive).async {
            semaphore.wait()
            DispatchQueue.main.async {
                if let image = _image { closure(image); semaphore.signal(); return }
                guard let window = UIApplication.shared.windows.first else { semaphore.signal(); return }
                let textField = UITextField(frame: CGRect(x: 0, y: -200, width: UIScreen.main.bounds.width, height: 44))
                window.rootViewController?.view.addSubview(textField)
                textField.text = "txt"
                textField.layoutIfNeeded()
                _image = textField.getClearButton()?.image(for: .normal)
                closure(_image)
                textField.removeFromSuperview()
                semaphore.signal()
            }
        }
    }
}
