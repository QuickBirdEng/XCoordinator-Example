//
//  HomeTabCoordinator.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit
import XCoordinator

/// Routes available within the home flow. Shared by all three home coordinators
/// (`HomeTabCoordinator`, `HomeSplitCoordinator`, `HomePageCoordinator`) — the same route enum drives
/// three different container types, which is the central teaching device of this example.
enum HomeRoute: Route {
    /// Surface the news flow (selects the news tab / detail column / page).
    case news
    /// Surface the user-list flow (selects the user-list tab / master column / page).
    case userList
}

/// Home flow rendered as a `UITabBarController`. Demonstrates `TabBarCoordinator` driving `HomeRoute`.
class HomeTabCoordinator: TabBarCoordinator<HomeRoute> {

    // MARK: Stored properties

    private let newsRouter: any Router<NewsRoute>
    private let userListRouter: any Router<UserListRoute>

    // MARK: Initialization

    convenience init() {
        let newsCoordinator = NewsCoordinator()
        newsCoordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 0)

        let userListCoordinator = UserListCoordinator()
        userListCoordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)

        self.init(newsRouter: newsCoordinator,
                  userListRouter: userListCoordinator)
    }

    init(newsRouter: any Router<NewsRoute>,
         userListRouter: any Router<UserListRoute>) {
        self.newsRouter = newsRouter
        self.userListRouter = userListRouter

        super.init(tabs: [newsRouter, userListRouter], select: userListRouter)
        rootViewController.view.accessibilityIdentifier = UITestIdentifiers.homeContainerTab
    }

    // MARK: Overrides

    override func prepareTransition(for route: HomeRoute) -> TabBarTransition {
        switch route {
        case .news:
            .select(newsRouter)
        case .userList:
            .select(userListRouter)
        }
    }

}
