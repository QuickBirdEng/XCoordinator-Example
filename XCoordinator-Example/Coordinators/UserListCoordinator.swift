//
//  UserListCoordinator.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 28.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCoordinator

/// Routes for the user-list flow: the home screen, the users list, a single user's detail,
/// logout, and the About screen (which is attached as a child coordinator, not presented).
enum UserListRoute: Route {
    /// Push the home screen. Used as the initial route.
    case home
    /// Push the users list.
    case users
    /// Present a modal detail screen for the named user, owned by a child `UserCoordinator`.
    case user(String)
    /// Dismiss this flow back to the login screen.
    case logout
    /// Attach an `AboutCoordinator` that pushes into the existing navigation stack.
    case about
}

/// User-list flow inside a `UINavigationController`. Owns the home screen, the users list, and
/// the about-coordinator attachment; presents `UserCoordinator` modally for user detail.
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
            let viewModel = HomeViewModelImpl(router: unownedRouter)
            viewController.bind(to: viewModel)
            return .push(viewController)
        case .users:
            let viewController = UsersViewController.instantiateFromNib()
            let viewModel = UsersViewModelImpl(userService: MockUserService(), router: unownedRouter)
            viewController.bind(to: viewModel)
            return .push(viewController, animation: .fade)
        case .user(let username):
            let coordinator = UserCoordinator(user: username)
            return .present(coordinator, animation: .default)
        case .logout:
            return .dismiss()
        case .about:
            // Child-coordinator idiom: `AboutCoordinator` reuses *this* coordinator's `UINavigationController`
            // (passed as `rootViewController`), so its pushes happen inside the same stack. Nothing needs to
            // be presented or pushed at this level — hence `.none()` paired with `addChild(...)`.
            addChild(AboutCoordinator(rootViewController: rootViewController))
            return .none()
        }
    }

}
