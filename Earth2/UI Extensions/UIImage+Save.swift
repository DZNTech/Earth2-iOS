//
//  UIImage+Save.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-16.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

extension UIImage {

    func save(with name: String) -> URL? {
        guard let data = self.jpegData(compressionQuality: 1) ?? self.pngData() else {
            return nil
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            return nil
        }

        do {
            let url = directory.appendingPathComponent("\(name).png")
            try data.write(to: url)
            return url
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    static func savedImage(named: String) -> UIImage? {
        guard let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
            return nil
        }
        return savedImage(with: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named))
    }

    static func savedImage(with url: URL) -> UIImage? {
        return UIImage(contentsOfFile: url.path)
    }
}
