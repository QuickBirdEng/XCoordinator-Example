//
//  HomePageCoordinator.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 30.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import XCoordinator

class HomePageCoordinator: PageCoordinator<HomeRoute> {

    // MARK: Stored properties

    private let newsRouter: any Presentable
    private let userListRouter: any Presentable

    // MARK: Initialization

    init(newsRouter: any Presentable = NewsCoordinator(),
         userListRouter: any Presentable = UserListCoordinator()) {
        self.newsRouter = newsRouter
        self.userListRouter = userListRouter
        
        super.init(
            rootViewController: .init(transitionStyle: .scroll,
                                      navigationOrientation: .horizontal,
                                      options: nil),
            pages: [userListRouter, newsRouter], loop: false,
            set: userListRouter, direction: .forward
        )
    }

    // MARK: Overrides

    override func prepareTransition(for route: HomeRoute) -> PageTransition {
        switch route {
        case .news:
            return .set(newsRouter, direction: .forward)
        case .userList:
            return .set(userListRouter, direction: .reverse)
        }
    }

}
