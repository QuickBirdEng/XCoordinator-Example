//
//  HomeViewModelImpl.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 20.11.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Combine
import XCoordinator

class HomeViewModelImpl: HomeViewModel, HomeViewModelInput, HomeViewModelOutput {

    // MARK: Inputs

    private(set) lazy var logoutTrigger = PassthroughSubject<Void, Never>()
    private(set) lazy var usersTrigger = PassthroughSubject<Void, Never>()
    private(set) lazy var aboutTrigger = PassthroughSubject<Void, Never>()

    // MARK: Actions

    private lazy var logoutAction = { [unowned self] in
        self.router.trigger(.logout)
    }

    private lazy var usersAction = { [unowned self] in
        self.router.trigger(.users)
    }

    private lazy var aboutAction = { [unowned self] in
        self.router.trigger(.about)
    }
    
    // MARK: Stored properties

    private let router: UnownedRouter<UserListRoute>
    private var cancellables = Set<AnyCancellable>()

    // MARK: Initialization

    init(router: UnownedRouter<UserListRoute>) {
        self.router = router
    }

    // MARK: Methods

    func registerPeek(for sourceView: Container) {
        router.trigger(.registerUsersPeek(from: sourceView))
        logoutTrigger
            .sink(receiveValue: logoutAction)
            .store(in: &cancellables)
        usersTrigger
            .sink(receiveValue: usersAction)
            .store(in: &cancellables)
        aboutTrigger
            .sink(receiveValue: aboutAction)
            .store(in: &cancellables)
    }
}
