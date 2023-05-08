//
//  TestRoute.swift
//  XCoordinator-ExampleTests
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

import XCoordinator

enum TestRoute<TransitionType: TransitionProtocol>: Route {
    case perform(TransitionType)
}
