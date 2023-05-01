//
//  HomeTabCoordinator.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit
import XCoordinator

enum HomeRoute: Route {
    case news
    case userList
}

class HomeTabCoordinator: TabBarCoordinator<HomeRoute> {

    // MARK: Stored properties

    private let newsRouter: any Presentable
    private let userListRouter: any Presentable

    // MARK: Initialization

    convenience init() {
        let newsCoordinator = NewsCoordinator()
        newsCoordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 0)

        let userListCoordinator = UserListCoordinator()
        userListCoordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)

        self.init(newsRouter: newsCoordinator, userListRouter: userListCoordinator)
    }

    init(newsRouter: any Presentable, userListRouter: any Presentable) {
        self.newsRouter = newsRouter
        self.userListRouter = userListRouter

        super.init(tabs: [newsRouter, userListRouter], select: userListRouter)
    }

    // MARK: Overrides

    override func prepareTransition(for route: HomeRoute) -> TabBarTransition {
        switch route {
        case .news:
            return .select(newsRouter)
        case .userList:
            return .select(userListRouter)
        }
    }

}
