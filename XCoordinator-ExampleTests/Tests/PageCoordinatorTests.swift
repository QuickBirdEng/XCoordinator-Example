//
//  PageCoordinatorTests.swift
//  XCoordinator-ExampleTests
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

@testable import XCoordinator_Example
import XCTest
import XCoordinator

@MainActor
class PageCoordinatorTests: CoordinatorTestCase<TestPageCoordinator> {

    // MARK: Overrides

    override func createCoordinator() -> TestPageCoordinator {
        .init(
            transitionStyle: .pageCurl,
            navigationOrientation: .vertical,
            isDoubleSided: name.contains("DoubleSided"),
            pages: viewControllers
        )
    }

    override func setUp() async throws {
        createViewControllers(count: 4)

        try await super.setUp()
    }

    // MARK: Methods

    func testSet() async {
        XCTAssertEqual(rootViewController.isDoubleSided, false)

        await perform(.set(viewControllers[1], direction: .forward))
        XCTAssertEqual(rootViewController.children.count, 1)
        XCTAssertEqual(rootViewController.viewControllers?[0], viewControllers[1])

        await perform(.set(viewControllers[0], direction: .reverse))
        XCTAssertEqual(rootViewController.children.count, 1)
        XCTAssertEqual(rootViewController.viewControllers?[0], viewControllers[0])
    }

    func testSetDoubleSided() async {
        XCTAssertEqual(rootViewController.isDoubleSided, true)

        await perform(.set(viewControllers[1], viewControllers[2], direction: .forward))
        XCTAssertEqual(rootViewController.children.count, 2)
        XCTAssertEqual(rootViewController.viewControllers?[0], viewControllers[1])
        XCTAssertEqual(rootViewController.viewControllers?[1], viewControllers[2])

        await perform(.set(viewControllers[0], viewControllers[1], direction: .reverse))
        XCTAssertEqual(rootViewController.children.count, 2)
        XCTAssertEqual(rootViewController.viewControllers?[0], viewControllers[0])
        XCTAssertEqual(rootViewController.viewControllers?[1], viewControllers[1])
    }

    func testSetDoubleOffset() async {
        XCTAssertEqual(rootViewController.isDoubleSided, false)

        await perform(.set(viewControllers[2], direction: .forward))
        XCTAssertEqual(rootViewController.children.count, 1)
        XCTAssertEqual(rootViewController.viewControllers?[0], viewControllers[2])

        await perform(.set(viewControllers[0], direction: .reverse))
        XCTAssertEqual(rootViewController.children.count, 1)
        XCTAssertEqual(rootViewController.viewControllers?[0], viewControllers[0])
    }

    func testSetDoubleOffsetDoubleSided() async {
        XCTAssertEqual(rootViewController.isDoubleSided, true)

        await perform(.set(viewControllers[2], viewControllers[3], direction: .forward))
        XCTAssertEqual(rootViewController.children.count, 2)
        XCTAssertEqual(rootViewController.viewControllers?[0], viewControllers[2])
        XCTAssertEqual(rootViewController.viewControllers?[1], viewControllers[3])

        await perform(.set(viewControllers[0], viewControllers[1], direction: .reverse))
        XCTAssertEqual(rootViewController.children.count, 2)
        XCTAssertEqual(rootViewController.viewControllers?[0], viewControllers[0])
        XCTAssertEqual(rootViewController.viewControllers?[1], viewControllers[1])
    }

}
