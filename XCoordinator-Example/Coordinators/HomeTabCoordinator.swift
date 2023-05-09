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

    private let newsRouter: any Router<NewsRoute>
    private let userListRouter: any Router<UserListRoute>

    // MARK: Initialization

    convenience init() {
        let newsCoordinator = NewsCoordinator()
        newsCoordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 0)

        let userListCoordinator = UserListCoordinator()
        userListCoordinator.rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)

        self.init(newsRouter: newsCoordinator, userListRouter: userListCoordinator)
    }

    init(newsRouter: any Router<NewsRoute>, userListRouter: any Router<UserListRoute>) {
        self.newsRouter = newsRouter
        self.userListRouter = userListRouter

        super.init(tabs: [newsRouter.asPresentable, userListRouter.asPresentable], select: userListRouter.asPresentable)
    }

    // MARK: Overrides

    @Prepare override func prepare(for route: HomeRoute) -> Transition<RootViewController> {
        switch route {
        case .news:
            SelectTab {
                self.newsRouter.asPresentable
            }
        case .userList:
            SelectTab {
                self.userListRouter.asPresentable
            }
        }
    }

}
