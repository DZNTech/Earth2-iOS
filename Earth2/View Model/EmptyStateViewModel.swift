//
//  EmptyStateViewModel.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-18.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit

protocol EmptyStateViewModelInterface {
    var title: NSAttributedString? { get }
    var description: NSAttributedString? { get }
    var image: UIImage? { get }
    var backgroundColor: UIColor? { get }

    func buttonTitle(_ state: UIControl.State) -> NSAttributedString?
}

enum EmptyState {
    case noFavorites
    case noProperties

    case error
    case noInternet
}

struct EmptyStateViewModel: EmptyStateViewModelInterface {

    var emptyState: EmptyState
    var isLoading = false

    init(_ emptyState: EmptyState) {
        self.emptyState = emptyState
    }

    var title: NSAttributedString? {

        var text: String?

        switch emptyState {
        case .noProperties:
            text = "No Properties"
        case .error:
            text = nil
        case .noInternet:
            text = "No Internet"
        default:
            return nil
        }

        guard let title = text else { return nil }

        var attributes: [NSAttributedString.Key: Any] = [:]
        attributes[NSAttributedString.Key.font] = Font.font(ofSize: 25, weight: .regular)
        attributes[NSAttributedString.Key.foregroundColor] = Color.gray100.withAlphaComponent(0.4)

        return NSAttributedString.init(string: title, attributes: attributes)
    }

    var description: NSAttributedString? {

        var text: String?

        switch emptyState {
        case .noFavorites:
            text = "You haven't saved any referral codes yet."
        case .noProperties:
            text = "You don't seem to own any properties yet."
        case .error:
            text = "Something went wrong. Please try again."
        default:
            return nil
        }

        guard let description = text else { return nil }

        var attributes: [NSAttributedString.Key: Any] = [:]
        attributes[NSAttributedString.Key.font] = Font.font(ofSize: 19, weight: .regular)
        attributes[NSAttributedString.Key.foregroundColor] = Color.gray200.withAlphaComponent(0.75)

        return NSAttributedString.init(string: description, attributes: attributes)
    }

    var image: UIImage? {
        return nil
    }

    func buttonTitle(_ state: UIControl.State) -> NSAttributedString? {

        var text: String?

        switch emptyState {
        case .noFavorites:
            text = "Add Code"
        case .error:
            text = "Reload"
        default:
            return nil
        }

        guard let title = text else { return nil }

        var attributes: [NSAttributedString.Key: Any] = [:]
        attributes[NSAttributedString.Key.font] = Font.font(ofSize: 19, weight: .medium)

        if state == .highlighted {
            attributes[NSAttributedString.Key.foregroundColor] = Color.white.withAlphaComponent(0.25)
        } else {
            attributes[NSAttributedString.Key.foregroundColor] = Color.white.withAlphaComponent(0.5)
        }

        return NSAttributedString.init(string: title, attributes: attributes)
    }

    var backgroundColor: UIColor? {
        return Color.clear
    }
}
