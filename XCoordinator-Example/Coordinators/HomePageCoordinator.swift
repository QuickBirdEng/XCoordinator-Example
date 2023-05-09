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

    private let newsRouter: any Router<NewsRoute>
    private let userListRouter: any Router<UserListRoute>

    // MARK: Initialization

    init(newsRouter: any Router<NewsRoute> = NewsCoordinator(),
         userListRouter: any Router<UserListRoute> = UserListCoordinator()) {
        self.newsRouter = newsRouter
        self.userListRouter = userListRouter
        
        super.init(
            rootViewController: .init(transitionStyle: .scroll,
                                      navigationOrientation: .horizontal,
                                      options: nil),
            pages: [userListRouter.asPresentable, newsRouter.asPresentable], loop: false,
            set: userListRouter.asPresentable, direction: .forward
        )
    }

    // MARK: Overrides

    @Prepare
    override func prepare(for route: HomeRoute) -> Transition<RootViewController> {
        switch route {
        case .news:
            PageSet(direction: .forward) {
                self.newsRouter.asPresentable
            }
        case .userList:
            PageSet(direction: .reverse) {
                self.userListRouter.asPresentable
            }
        }
    }

}
