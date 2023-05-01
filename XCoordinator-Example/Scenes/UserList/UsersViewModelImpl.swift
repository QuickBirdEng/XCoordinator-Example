//
//  UsersViewModelImpl.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 20.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Action
import RxSwift
import XCoordinator

class UsersViewModelImpl: UsersViewModel, UsersViewModelInput, UsersViewModelOutput {

    // MARK: Inputs

    private(set) lazy var showUserTrigger = showUserAction.inputs

    // MARK: Actions

    private lazy var showUserAction = Action<User, Void> { [unowned self] user in
        self.router.rxTrigger(.user(user.name))
    }

    // MARK: Outputs

    private(set) lazy var users = Observable.just(userService.allUsers())

    // MARK: Stored properties

    private let userService: UserService
    private unowned let router: any Router<UserListRoute>

    // MARK: Initialization

    init(userService: UserService, router: any Router<UserListRoute>) {
        self.userService = userService
        self.router = router
    }

}
