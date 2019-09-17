//
//  UserViewModelImpl.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 20.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Action
import RxSwift
import XCoordinator

class UserViewModelImpl: UserViewModel, UserViewModelInput, UserViewModelOutput {

    // MARK: - Inputs

    private(set) lazy var alertTrigger = alertAction.inputs
    private(set) lazy var closeTrigger = closeAction.inputs

    // MARK: - Actions

    private lazy var alertAction = CocoaAction { [unowned self] in
        self.router.rx.trigger(.alert(title: "Hey", message: "You are awesome!"))
    }

    private lazy var closeAction = CocoaAction { [unowned self] in
        self.router.rx.trigger(.users)
    }

    // MARK: - Outputs

    let username: Observable<String>

    // MARK: - Private

    private let router: UnownedRouter<UserRoute>

    // MARK: - Init

    init(router: UnownedRouter<UserRoute>, username: String) {
        self.router = router
        self.username = .just(username)
    }
}
