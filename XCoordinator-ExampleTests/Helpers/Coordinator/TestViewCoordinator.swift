//
//  TestViewCoordinator.swift
//  XCoordinator-ExampleTests
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

import XCoordinator

class TestViewCoordinator: ViewCoordinator<TestRoute<ViewTransition>> {

    override func prepareTransition(for route: RouteType) -> TransitionType {
        switch route {
        case let .perform(transition):
            return transition
        }
    }

}
