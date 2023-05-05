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

    override func prepareTransition(for route: UserListRoute) -> NavigationTransition {
        switch route {
        case .home:
            let viewController = HomeViewController.instantiateFromNib()
            let viewModel = HomeViewModelImpl(router: self)
            viewController.bind(to: viewModel)
            return .push(viewController)
        case .users:
            let viewController = UsersViewController.instantiateFromNib()
            let viewModel = UsersViewModelImpl(userService: MockUserService(), router: self)
            viewController.bind(to: viewModel)
            return .push(viewController, animation: .fade)
        case .user(let username):
            let coordinator = UserCoordinator(user: username)
            return .present(coordinator, animation: .default)
        case .registerUsersPeek(let source):
            if #available(iOS 13.0, *) {
                return .none()
            } else {
                return registerPeek(for: source, route: .users)
            }
        case .logout:
            return .dismiss()
        case .about:
            addChild(AboutCoordinator(rootViewController: rootViewController))
            return .none()
        }
    }

}
