//
//  HomeSplitCoordinator.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCoordinator

class HomeSplitCoordinator: SplitCoordinator<HomeRoute> {

    // MARK: Stored properties

    private let newsRouter: any Presentable
    private let userListRouter: any Presentable

    // MARK: Initialization

    init(newsRouter: any Presentable = NewsCoordinator(),
         userListRouter: any Presentable = UserListCoordinator()) {
        self.newsRouter = newsRouter
        self.userListRouter = userListRouter

        super.init(primary: userListRouter, secondary: newsRouter)
    }

    // MARK: Overrides

    override func prepareTransition(for route: HomeRoute) -> SplitTransition {
        switch route {
        case .news:
            return .showDetail(newsRouter)
        case .userList:
            return .show(userListRouter)
        }
    }

}
