//
//  UserViewModelImpl.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 20.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Action
import RxSwift
import XCoordinator

class UserViewModelImpl: UserViewModel, UserViewModelInput, UserViewModelOutput {

    // MARK: Inputs

    private(set) lazy var alertTrigger = alertAction.inputs
    private(set) lazy var closeTrigger = closeAction.inputs

    // MARK: Actions

    private lazy var alertAction = CocoaAction { [unowned self] in
        self.router.rxTrigger(.alert(title: "Hey", message: "You are awesome!"))
    }

    private lazy var closeAction = CocoaAction { [unowned self] in
        self.router.rxTrigger(.users)
    }

    // MARK: Outputs

    let username: Observable<String>

    // MARK: Stored properties

    private unowned let router: any Router<UserRoute>

    // MARK: Initialization

    init(router: any Router<UserRoute>, username: String) {
        self.router = router
        self.username = .just(username)
    }
}
