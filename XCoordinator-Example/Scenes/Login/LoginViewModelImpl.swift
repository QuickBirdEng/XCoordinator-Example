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
        self.router.rxTrigger(.home(nil))
    }

    // MARK: Stored properties

    private unowned let router: any Router<AppRoute>

    // MARK: Initialization

    init(router: any Router<AppRoute>) {
        self.router = router
    }
}
