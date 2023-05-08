//
//  TabBarCoordinatorTests.swift
//  XCoordinator-ExampleTests
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

import XCTest
import XCoordinator

@MainActor
class TabBarCoordinatorTests: CoordinatorTestCase<TestTabBarCoordinator> {

    // MARK: Overrides

    override func createCoordinator() -> TestTabBarCoordinator {
        .init(tabs: viewControllers)
    }

    override func setUp() async throws {
        createViewControllers(count: 5)

        try await super.setUp()
    }

    // MARK: Methods

    func testSelect() async {
        for viewController in viewControllers.reversed() {
            await perform(.select(viewController))
            XCTAssertEqual(rootViewController.selectedViewController, viewController)
        }
    }

    func testSelectAnimated() async {
        for viewController in viewControllers.reversed() {
            await performWithAnimation { .select(viewController, animation: $0) }
            XCTAssertEqual(rootViewController.selectedViewController, viewController)

            sleepAsync(for: 1)
        }
    }

}
