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

    private let newsRouter: any Router<NewsRoute>
    private let userListRouter: any Router<UserListRoute>

    // MARK: Initialization

    init(newsRouter: any Router<NewsRoute> = NewsCoordinator(),
         userListRouter: any Router<UserListRoute> = UserListCoordinator()) {
        self.newsRouter = newsRouter
        self.userListRouter = userListRouter

        super.init(primary: userListRouter.asPresentable, secondary: newsRouter.asPresentable)
    }

    // MARK: Overrides

    override func prepareTransition(for route: HomeRoute) -> SplitTransition {
        switch route {
        case .news:
            return .showDetail(newsRouter.asPresentable)
        case .userList:
            return .show(userListRouter.asPresentable)
        }
    }

}

extension Router {

    var asPresentable: any Presentable {
        self
    }

}
