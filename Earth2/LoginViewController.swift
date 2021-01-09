//
//  LoginViewController.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-08.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import UIKit
import E2API

class LoginViewController: UIViewController {

    let authApi = AuthApi()
    let propertyApi = PropertyApi()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red

        authApi.login("ignacio.romeroz@gmail.com", password: "d@GMOVH{q+8AY,71U}xBtwISEdr") { (user, error) in
            
        }

        propertyApi.getMyProperties { (properties, error) in
            
        }
    }
}

