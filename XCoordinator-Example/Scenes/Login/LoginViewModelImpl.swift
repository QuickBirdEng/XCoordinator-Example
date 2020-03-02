//
//  LoginViewModelImpl.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 20.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Combine
import XCoordinator

class LoginViewModelImpl: LoginViewModel, LoginViewModelInput, LoginViewModelOutput {

    // MARK: Inputs

    private(set) var loginTrigger = PassthroughSubject<Void, Never>()

    // MARK: Actions

    private lazy var loginAction = { [unowned self] in
        self.router.trigger(.home(nil))
    }

    // MARK: Stored properties

    private let router: UnownedRouter<AppRoute>
    private var cancellables = Set<AnyCancellable>()

    // MARK: Initialization

    init(router: UnownedRouter<AppRoute>) {
        self.router = router
        loginTrigger
            .sink(receiveValue: loginAction)
            .store(in: &cancellables)
    }
}
