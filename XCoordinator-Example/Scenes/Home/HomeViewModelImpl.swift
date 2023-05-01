//
//  HomeViewModelImpl.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 20.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Action
import RxSwift
import XCoordinator
import XCoordinatorRx

class HomeViewModelImpl: HomeViewModel, HomeViewModelInput, HomeViewModelOutput {

    // MARK: Inputs

    private(set) lazy var logoutTrigger = logoutAction.inputs
    private(set) lazy var usersTrigger = usersAction.inputs
    private(set) lazy var aboutTrigger = aboutAction.inputs

    // MARK: Actions

    private lazy var logoutAction = CocoaAction { [unowned self] in
        self.router.rxTrigger(.logout)
    }

    private lazy var usersAction = CocoaAction { [unowned self] in
        self.router.rxTrigger(.users)
    }

    private lazy var aboutAction = CocoaAction { [unowned self] in
        self.router.rxTrigger(.about)
    }
    // MARK: Stored properties

    private unowned let router: any Router<UserListRoute>

    // MARK: Initialization

    init(router: any Router<UserListRoute>) {
        self.router = router
    }

    // MARK: Methods

    func registerPeek(for sourceView: Container) {
        router.trigger(.registerUsersPeek(from: sourceView))
    }

}
