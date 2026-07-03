//
//  HomeSplitCoordinator.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCoordinator

/// Home flow rendered as a `UISplitViewController`. Demonstrates `SplitCoordinator` driving `HomeRoute`
/// — same routes as `HomeTabCoordinator`, different container.
class HomeSplitCoordinator: SplitCoordinator<HomeRoute> {

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

        super.init(primary: userListRouter, secondary: newsRouter)
        rootViewController.view.accessibilityIdentifier = UITestIdentifiers.homeContainerSplit
    }

    // MARK: Overrides

    override func prepareTransition(for route: HomeRoute) -> SplitTransition {
        switch route {
        case .news:
            .showDetail(newsRouter)
        case .userList:
            .show(userListRouter)
        }
    }

}
