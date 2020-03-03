//
//  UsersViewModelImpl.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 20.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Combine
import XCoordinator

class UsersViewModelImpl: UsersViewModel, UsersViewModelInput, UsersViewModelOutput {

    // MARK: Inputs

    private(set) lazy var showUserTrigger = PassthroughSubject<User, Never>()

    // MARK: Actions

    private lazy var showUserAction: (User) -> Void = { [unowned self] user in
        self.router.trigger(.user(user.name))
    }

    // MARK: Outputs

    private(set) lazy var users = Just(userService.allUsers()).eraseToAnyPublisher()

    // MARK: Stored properties

    private let userService: UserService
    private let router: UnownedRouter<UserListRoute>
    private var cancellables = Set<AnyCancellable>()

    // MARK: Initialization

    init(userService: UserService, router: UnownedRouter<UserListRoute>) {
        self.userService = userService
        self.router = router
        showUserTrigger
            .sink(receiveValue: showUserAction)
            .store(in: &cancellables)
    }
}
