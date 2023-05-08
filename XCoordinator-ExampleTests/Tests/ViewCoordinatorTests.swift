//
//  ViewCoordinatorTests.swift
//  XCoordinator-ExampleTests
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

import XCTest
import XCoordinator

@MainActor
class ViewCoordinatorTests: CoordinatorTestCase<TestViewCoordinator> {

    // MARK: Overrides

    override func createCoordinator() -> TestViewCoordinator {
        .init(rootViewController: viewControllers[0])
    }

    override func setUp() async throws {
        createViewControllers(count: 5)

        try await super.setUp()
    }

    // MARK: Methods

    func testPresent() async {
        XCTAssert(coordinator.children.isEmpty)

        await perform(.present(viewControllers[1]))
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssert(coordinator.children.isEmpty)

        await perform(.present(viewControllers[2]))
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssertEqual(viewControllers[1].presentedViewController, viewControllers[2])
        XCTAssert(coordinator.children.isEmpty)

        await perform(.present(viewControllers[3]))
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssertEqual(viewControllers[1].presentedViewController, viewControllers[2])
        XCTAssertEqual(viewControllers[2].presentedViewController, viewControllers[3])
        XCTAssert(coordinator.children.isEmpty)

        await perform(.present(viewControllers[4]))
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssertEqual(viewControllers[1].presentedViewController, viewControllers[2])
        XCTAssertEqual(viewControllers[2].presentedViewController, viewControllers[3])
        XCTAssertEqual(viewControllers[3].presentedViewController, viewControllers[4])
        XCTAssert(coordinator.children.isEmpty)

        await perform(.dismiss())
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssertEqual(viewControllers[1].presentedViewController, viewControllers[2])
        XCTAssertEqual(viewControllers[2].presentedViewController, viewControllers[3])
        XCTAssertNil(viewControllers[3].presentedViewController)
        XCTAssert(coordinator.children.isEmpty)

        await perform(.dismiss())
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssertEqual(viewControllers[1].presentedViewController, viewControllers[2])
        XCTAssertNil(viewControllers[2].presentedViewController)
        XCTAssert(coordinator.children.isEmpty)

        await perform(.dismiss())
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssertNil(viewControllers[1].presentedViewController)
        XCTAssert(coordinator.children.isEmpty)

        await perform(.dismiss())
        XCTAssertNil(viewControllers[0].presentedViewController)
        XCTAssert(coordinator.children.isEmpty)
    }

    func testPresentAnimated() async {
        await performWithAnimation { .present(viewControllers[1], animation: $0) }
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssert(coordinator.children.isEmpty)

        await performWithAnimation { .present(viewControllers[2], animation: $0) }
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssertEqual(viewControllers[1].presentedViewController, viewControllers[2])
        XCTAssert(coordinator.children.isEmpty)

        await performWithAnimation { .present(viewControllers[3], animation: $0) }
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssertEqual(viewControllers[1].presentedViewController, viewControllers[2])
        XCTAssertEqual(viewControllers[2].presentedViewController, viewControllers[3])
        XCTAssert(coordinator.children.isEmpty)

        await performWithAnimation { .present(viewControllers[4], animation: $0) }
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssertEqual(viewControllers[1].presentedViewController, viewControllers[2])
        XCTAssertEqual(viewControllers[2].presentedViewController, viewControllers[3])
        XCTAssertEqual(viewControllers[3].presentedViewController, viewControllers[4])
        XCTAssert(coordinator.children.isEmpty)

        await performWithAnimation(isPresenting: false) { .dismiss(animation: $0) }
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssertEqual(viewControllers[1].presentedViewController, viewControllers[2])
        XCTAssertEqual(viewControllers[2].presentedViewController, viewControllers[3])
        XCTAssertNil(viewControllers[3].presentedViewController)
        XCTAssert(coordinator.children.isEmpty)

        await performWithAnimation(isPresenting: false) { .dismiss(animation: $0) }
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssertEqual(viewControllers[1].presentedViewController, viewControllers[2])
        XCTAssertNil(viewControllers[2].presentedViewController)
        XCTAssert(coordinator.children.isEmpty)

        await performWithAnimation(isPresenting: false) { .dismiss(animation: $0) }
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssertNil(viewControllers[1].presentedViewController)
        XCTAssert(coordinator.children.isEmpty)

        await performWithAnimation(isPresenting: false) { .dismiss(animation: $0) }
        XCTAssertNil(viewControllers[0].presentedViewController)
        XCTAssert(coordinator.children.isEmpty)
    }

    func testPresentViewCoordinators() async {
        let coordinators = viewControllers.dropFirst().map { TestViewCoordinator(rootViewController: $0) }
        XCTAssert(coordinator.children.isEmpty)

        await perform(.present(coordinators[0]))
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssertEqual(coordinator.children.count, 1)

        await perform(.present(coordinators[1]))
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssertEqual(viewControllers[1].presentedViewController, viewControllers[2])
        XCTAssertEqual(coordinator.children.count, 2)

        await perform(.present(coordinators[2]))
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssertEqual(viewControllers[1].presentedViewController, viewControllers[2])
        XCTAssertEqual(viewControllers[2].presentedViewController, viewControllers[3])
        XCTAssertEqual(coordinator.children.count, 3)

        await perform(.present(coordinators[3]))
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssertEqual(viewControllers[1].presentedViewController, viewControllers[2])
        XCTAssertEqual(viewControllers[2].presentedViewController, viewControllers[3])
        XCTAssertEqual(viewControllers[3].presentedViewController, viewControllers[4])
        XCTAssertEqual(coordinator.children.count, 4)

        await perform(.dismiss())
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssertEqual(viewControllers[1].presentedViewController, viewControllers[2])
        XCTAssertEqual(viewControllers[2].presentedViewController, viewControllers[3])
        XCTAssertNil(viewControllers[3].presentedViewController)
        XCTAssertEqual(coordinator.children.count, 3)

        await perform(.dismiss())
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssertEqual(viewControllers[1].presentedViewController, viewControllers[2])
        XCTAssertNil(viewControllers[2].presentedViewController)
        XCTAssertEqual(coordinator.children.count, 2)

        await perform(.dismiss())
        XCTAssertEqual(viewControllers[0].presentedViewController, viewControllers[1])
        XCTAssertNil(viewControllers[1].presentedViewController)
        XCTAssertEqual(coordinator.children.count, 1)

        await perform(.dismiss())
        XCTAssertNil(viewControllers[0].presentedViewController)
        XCTAssert(coordinator.children.isEmpty)
    }

}
