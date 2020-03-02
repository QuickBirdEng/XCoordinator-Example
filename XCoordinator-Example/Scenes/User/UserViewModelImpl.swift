//
//  UserViewModelImpl.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 20.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Combine
import XCoordinator

class UserViewModelImpl: UserViewModel, UserViewModelInput, UserViewModelOutput {

    // MARK: Inputs

    private(set) lazy var alertTrigger = PassthroughSubject<Void, Never>()
    private(set) lazy var closeTrigger = PassthroughSubject<Void, Never>()

    // MARK: Actions

    private lazy var alertAction = { [unowned self] in
        self.router.trigger(.alert(title: "Hey", message: "You are awesome!"))
    }

    private lazy var closeAction = { [unowned self] in
        self.router.trigger(.users)
    }

    // MARK: Outputs

    let username: AnyPublisher<String?, Never>

    // MARK: Stored properties

    private let router: UnownedRouter<UserRoute>
    private var cancellables = Set<AnyCancellable>()

    // MARK: Initialization

    init(router: UnownedRouter<UserRoute>, username: String) {
        self.router = router
        self.username = Just(username).eraseToAnyPublisher()
        alertTrigger
            .sink(receiveValue: alertAction)
            .store(in: &cancellables)
        closeTrigger
            .sink(receiveValue: closeAction)
            .store(in: &cancellables)
    }
}
