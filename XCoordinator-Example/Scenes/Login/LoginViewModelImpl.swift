//
//  LoginViewModelImpl.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 20.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Action
import RxSwift
import XCoordinator

class LoginViewModelImpl: LoginViewModel, LoginViewModelInput, LoginViewModelOutput {

    // MARK: Inputs

    private(set) lazy var loginTrigger = loginAction.inputs

    // MARK: Actions

    private lazy var loginAction = CocoaAction { [unowned self] in
        self.router.rx.trigger(.home(nil))
    }

    // MARK: Stored properties

    private let router: UnownedRouter<AppRoute>

    // MARK: Initialization

    init(router: UnownedRouter<AppRoute>) {
        self.router = router
    }
}
