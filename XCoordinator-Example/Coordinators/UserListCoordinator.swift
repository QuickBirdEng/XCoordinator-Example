//
//  UserListCoordinator.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCoordinator

enum UserListRoute: Route {
    case home
    case users
    case user(String)
    case registerUsersPeek(from: Container)
    case logout
    case about
}

class UserListCoordinator: NavigationCoordinator<UserListRoute> {

    // MARK: Initialization
    
    init() {
        super.init(initialRoute: .home)
    }

    // MARK: Overrides

    @Prepare
    override func prepare(for route: UserListRoute) -> Transition<RootViewController> {
        switch route {
        case .home:
            Push {
                let viewController = HomeViewController.instantiateFromNib()
                let viewModel = HomeViewModelImpl(router: self)
                viewController.bind(to: viewModel)
                return viewController
            }
        case .users:
            Push(animation: .fade) {
                let viewController = UsersViewController.instantiateFromNib()
                let viewModel = UsersViewModelImpl(userService: MockUserService(), router: self)
                viewController.bind(to: viewModel)
                return viewController
            }
        case .user(let username):
            Present(animation: .default) {
                UserCoordinator(user: username)
            }
        case .registerUsersPeek(let source):
            if #unavailable(iOS 13) {
                RegisterPeek(for: .users, on: self, in: source)
            }
        case .logout:
            Dismiss()
        case .about:
            addChild(AboutCoordinator(rootViewController: rootViewController))
        }
    }

}
