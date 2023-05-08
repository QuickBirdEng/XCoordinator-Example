//
//  TestTabBarCoordinator.swift
//  XCoordinator-ExampleTests
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

import XCoordinator

class TestTabBarCoordinator: TabBarCoordinator<TestRoute<TabBarTransition>> {

    override func prepareTransition(for route: RouteType) -> TransitionType {
        switch route {
        case let .perform(transition):
            return transition
        }
    }

}
