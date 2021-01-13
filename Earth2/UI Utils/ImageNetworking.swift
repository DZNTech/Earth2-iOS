//
//  ImageNetworking.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-12.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

public typealias ImageBlock = (_ image: UIImage?) -> Void

class ImageNetworking {

    static func cachedImage(for urlString: String) -> UIImage? {
        let imageDownloader = UIImageView.af_sharedImageDownloader
        guard let url = URL(string: urlString) else { return nil }
        return imageDownloader.imageCache?.image(for: URLRequest(url: url), withIdentifier: Self.originalFilter.identifier)
    }

    fileprivate static var originalFilter: ImageFilter {
        return DynamicImageFilter("OriginalFilterImage") { image in
            return image.withRenderingMode(.alwaysOriginal)
        }
    }
}

extension UIImageView {

    func setImageUrl(_ urlString: String?, placeholderImage: UIImage?, renderingMode: UIImage.RenderingMode = .alwaysOriginal, completion: ImageBlock? = nil) {
        guard let urlString = urlString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString), url.host != nil else {
            image = placeholderImage
            return
        }

        af_setImage(withURL: url, placeholderImage: placeholderImage, filter: ImageNetworking.originalFilter,
        completion: { response in
            switch response.result {
            case .success(let image):
                completion?(image)
            case .failure:
                completion?(nil)
            }
        })
    }
}

extension UIButton {
    func setImage(with urlString: String?, placeholderImage: UIImage?, forState state: UIControl.State = .normal, renderingMode: UIImage.RenderingMode = .alwaysOriginal, completion: ImageBlock? = nil) {
        if let urlString = urlString, let url = URL(string: urlString) {
            af_setImage(for: state, url: url, placeholderImage: placeholderImage, filter: ImageNetworking.originalFilter,
            completion: { response in
                switch response.result {
                case .success(let image):
                    completion?(image)
                case .failure:
                    completion?(nil)
                }
            })
        } else {
            setImage(placeholderImage, for: state)
        }
    }
}
