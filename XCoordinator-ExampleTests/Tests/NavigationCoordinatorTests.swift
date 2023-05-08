//
//  NavigationCoordinatorTests.swift
//  XCoordinator-ExampleTests
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

import XCTest
import XCoordinator

@MainActor
class NavigationCoordinatorTests: CoordinatorTestCase<TestNavigationCoordinator> {

    // MARK: Overrides

    override func createCoordinator() -> TestNavigationCoordinator {
        .init(root: viewControllers[0])
    }

    override func setUp() async throws {
        createViewControllers(count: 5)

        try await super.setUp()
    }

    // MARK: Methods

    func testPush() async {
        await perform(.push(viewControllers[1]))
        XCTAssertEqual(rootViewController.viewControllers.count, 2)
        XCTAssertEqual(viewControllers[1].navigationController, rootViewController)

        await perform(.pop())
        XCTAssertEqual(rootViewController.viewControllers.count, 1)
        XCTAssertNil(viewControllers[1].navigationController)

        await perform(.multiple(.push(viewControllers[1]), .push(viewControllers[2])))
        XCTAssertEqual(rootViewController.viewControllers.count, 3)
        XCTAssertEqual(viewControllers[1].navigationController, rootViewController)
        XCTAssertEqual(viewControllers[2].navigationController, rootViewController)

        await perform(.popToRoot())
        XCTAssertEqual(rootViewController.viewControllers.count, 1)
        XCTAssertNil(viewControllers[1].navigationController)
        XCTAssertNil(viewControllers[2].navigationController)
    }

    func testPushAnimated() async {
        await performWithAnimation { .push(viewControllers[1], animation: $0) }
        XCTAssertEqual(rootViewController.viewControllers.count, 2)
        XCTAssertEqual(viewControllers[1].navigationController, rootViewController)

        await performWithAnimation(isPresenting: false) { .pop(animation: $0) }
        XCTAssertEqual(rootViewController.viewControllers.count, 1)
        XCTAssertNil(viewControllers[1].navigationController)

        await performWithAnimation { .multiple(.push(viewControllers[1]), .push(viewControllers[2], animation: $0)) }
        XCTAssertEqual(rootViewController.viewControllers.count, 3)
        XCTAssertEqual(viewControllers[1].navigationController, rootViewController)
        XCTAssertEqual(viewControllers[2].navigationController, rootViewController)

        await performWithAnimation(isPresenting: false) { .multiple(.pop(), .pop(animation: $0)) }
        XCTAssertEqual(rootViewController.viewControllers.count, 1)
        XCTAssertNil(viewControllers[1].navigationController)
        XCTAssertNil(viewControllers[2].navigationController)
    }

    func testPushViewCoordinators() async {
        let coordinators = viewControllers.dropFirst().map { TestViewCoordinator(rootViewController: $0) }
        XCTAssert(coordinator.children.isEmpty)

        await perform(.push(coordinators[0]))
        XCTAssertEqual(rootViewController.viewControllers.count, 2)
        XCTAssertEqual(coordinator.children.count, 1)

        await perform(.push(coordinators[1]))
        XCTAssertEqual(rootViewController.viewControllers.count, 3)
        XCTAssertEqual(coordinator.children.count, 2)

        await perform(.pop())
        XCTAssertEqual(rootViewController.viewControllers.count, 2)
        XCTAssertEqual(coordinator.children.count, 1)

        await perform(.pop())
        XCTAssertEqual(rootViewController.viewControllers.count, 1)
        XCTAssert(coordinator.children.isEmpty)

        await perform(.multiple(.push(coordinators[0]), .push(coordinators[1])))
        XCTAssertEqual(rootViewController.viewControllers.count, 3)
        XCTAssertEqual(viewControllers[1].navigationController, rootViewController)
        XCTAssertEqual(viewControllers[2].navigationController, rootViewController)
        XCTAssertEqual(coordinator.children.count, 2)

        await perform(.pop(to: viewControllers[0]))
        XCTAssertEqual(rootViewController.viewControllers.count, 1)
        XCTAssert(coordinator.children.isEmpty)
    }

    func testSet() async {
        let coordinators = viewControllers.map { TestViewCoordinator(rootViewController: $0) }
        XCTAssert(coordinator.children.isEmpty)

        await performWithAnimation { .set(coordinators, animation: $0) }
        XCTAssertEqual(rootViewController.viewControllers.count, coordinators.count)
        XCTAssertEqual(coordinator.children.count, coordinators.count)

        await performWithAnimation(isPresenting: false) { .popToRoot(animation: $0) }
        XCTAssertEqual(rootViewController.viewControllers.count, 1)
        XCTAssertEqual(coordinator.children.count, 1)
    }

    /*
     public static func push(_ presentable: Presentable, animation: Animation? = nil)
     public static func pop(animation: Animation? = nil)
     public static func pop(to presentable: Presentable, animation: Animation? = nil)
     public static func popToRoot(animation: Animation? = nil)
     public static func set(_ presentables: [Presentable], animation: Animation? = nil)
     */

}
