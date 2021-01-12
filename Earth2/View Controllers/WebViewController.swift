//
//  WebViewController.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-12.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import SafariServices
import E2API

class WebViewController: SFSafariViewController {

    // MARK: - Public Static Convenience Methods

    static func open(_ web: WebConstant) {
        openUrl(web.rawValue)
    }

    static func openUrl(_ url: String) {
        guard let url = URL(string: url) else { return }

        let webvc = WebViewController(url: url)
        UIViewController.topMostViewController()?.present(webvc, animated: true, completion: nil)
    }

    // MARK: - Initialization

    init(url URL: URL) {
        super.init(url: URL, configuration: Self.Configuration())
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
    }

    // MARK: - Layout

    func configureLayout() {
        preferredBarTintColor = Color.navigationBarColor
        preferredControlTintColor = Color.blue
        dismissButtonStyle = .close
    }

}
