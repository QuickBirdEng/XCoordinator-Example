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

    private let newsRouter: any Router<NewsRoute>
    private let userListRouter: any Router<UserListRoute>

    // MARK: Initialization

    convenience init() {
        self.init(newsRouter: NewsCoordinator(), userListRouter: UserListCoordinator())
    }

    init(newsRouter: any Router<NewsRoute>,
         userListRouter: any Router<UserListRoute>) {
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
        // XCoordinator 3's stock `.set` already calls its completion even when the target page is already
        // on-screen, so deep links chaining through this coordinator no longer stall (this used to require a
        // custom `.setReliably`, since removed).
        switch route {
        case .news:
            .set(newsRouter, direction: .forward)
        case .userList:
            .set(userListRouter, direction: .reverse)
        }
    }

}
