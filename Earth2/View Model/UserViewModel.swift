//
//  UserViewModel.swift
//  Earth2
//
//  Created by Ignacio Romero Zurbuchen on 2021-01-15.
//  Copyright © 2021 DZN Technologies Inc. All rights reserved.
//

import E2API

public class UserViewModel: Descriptable {

    // MARK: - Public Variables

    let user: User

    // MARK: - Initializatiom

    init(with user: User) {
        self.user = user
    }
}
