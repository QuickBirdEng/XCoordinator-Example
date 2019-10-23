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
