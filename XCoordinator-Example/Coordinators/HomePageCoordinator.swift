//
//  HomePageCoordinator.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCoordinator

/// Home flow rendered as a horizontally-scrolling `UIPageViewController`. Demonstrates `PageCoordinator`
/// driving `HomeRoute` — same routes as `HomeTabCoordinator`, different container.
class HomePageCoordinator: PageCoordinator<HomeRoute> {

    // MARK: Stored properties

    private let newsRouter: StrongRouter<NewsRoute>
    private let userListRouter: StrongRouter<UserListRoute>

    // MARK: Initialization

    init(newsRouter: StrongRouter<NewsRoute> = NewsCoordinator().strongRouter,
         userListRouter: StrongRouter<UserListRoute> = UserListCoordinator().strongRouter) {
        self.newsRouter = newsRouter
        self.userListRouter = userListRouter

        super.init(
            rootViewController: .init(transitionStyle: .scroll,
                                      navigationOrientation: .horizontal,
                                      options: nil),
            pages: [userListRouter, newsRouter], loop: false,
            set: userListRouter, direction: .forward
        )
        rootViewController.view.accessibilityIdentifier = UITestIdentifiers.homeContainerPage
    }

    // MARK: Overrides

    override func prepareTransition(for route: HomeRoute) -> PageTransition {
        // `setReliably` instead of the stock `.set` so that deep links chaining through this coordinator
        // don't stall when the target page is already on-screen — see Extensions/Transitions.swift.
        switch route {
        case .news:
            return .setReliably(newsRouter, direction: .forward)
        case .userList:
            return .setReliably(userListRouter, direction: .reverse)
        }
    }

}
