//
//  SplitCoordinatorTests.swift
//  XCoordinator-ExampleTests
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

import XCTest
import XCoordinator

@available(iOS 14, *)
@MainActor
class SplitCoordinatorTests: CoordinatorTestCase<TestSplitCoordinator> {

    // MARK: Computed Properties

    var navigationController: UINavigationController? {
        rootViewController.viewControllers.first as? UINavigationController
    }

    // MARK: Overrides

    override func createCoordinator() -> TestSplitCoordinator {
        if name.contains("DoubleColumn") {
            return .init(
                rootViewController: .init(style: .doubleColumn),
                primary: viewControllers[0],
                secondary: viewControllers[1]
            )
        } else if name.contains("TripleColumn") {
            return .init(
                rootViewController: .init(style: .tripleColumn),
                primary: viewControllers[0],
                secondary: viewControllers[1],
                supplementary: viewControllers[2]
            )
        } else if name.contains("Unspecified") {
            return .init(
                primary: viewControllers[0],
                secondary: viewControllers[1]
            )
        } else {
            fatalError("Unrecognized test name.")
        }
    }

    override func setUp() async throws {
        // TODO Make sure to adapt the tests to work on both phone and pad
        try XCTSkipIf(UIDevice.current.userInterfaceIdiom == .phone)

        createViewControllers(count: 4)

        try await super.setUp()
    }

    // MARK: Methods

    func testUnspecifiedSetPrimary() async {
        XCTAssertEqual(rootViewController.viewControllers.count, 2)
        XCTAssertEqual(rootViewController.viewControllers[0], viewControllers[0])
        XCTAssertEqual(rootViewController.viewControllers[1], viewControllers[1])

        await perform(.set([viewControllers[2], viewControllers[1]]))
        XCTAssertEqual(rootViewController.viewControllers.count, 2)
        XCTAssertEqual(rootViewController.viewControllers[0], viewControllers[2])
        XCTAssertEqual(rootViewController.viewControllers[1], viewControllers[1])
    }

    func testUnspecifiedSetSecondary() async {
        XCTAssertEqual(rootViewController.viewControllers.count, 2)
        XCTAssertEqual(rootViewController.viewControllers[0], viewControllers[0])
        XCTAssertEqual(rootViewController.viewControllers[1], viewControllers[1])

        await perform(.set([viewControllers[0], viewControllers[2]]))
        XCTAssertEqual(rootViewController.viewControllers.count, 2)
        XCTAssertEqual(rootViewController.viewControllers[0], viewControllers[0])
        XCTAssertEqual(rootViewController.viewControllers[1], viewControllers[2])
    }

    func testDoubleColumnSetPrimary() async {
        XCTAssertEqual(rootViewController.viewControllers.count, 2)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.first, viewControllers[0])
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.first, viewControllers[1])

        await perform(.set(viewControllers[2], for: .primary))
        XCTAssertEqual(rootViewController.viewControllers.count, 2)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.first, viewControllers[2])
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.first, viewControllers[1])
    }

    func testDoubleColumnSetSecondary() async {
        XCTAssertEqual(rootViewController.viewControllers.count, 2)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.first, viewControllers[0])
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.first, viewControllers[1])

        await perform(.set(viewControllers[2], for: .secondary))
        XCTAssertEqual(rootViewController.viewControllers.count, 2)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.first, viewControllers[0])
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.count, 2)
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers[0], viewControllers[1])
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers[1], viewControllers[2])

        await perform(.set(viewControllers[3], for: .secondary))
        XCTAssertEqual(rootViewController.viewControllers.count, 2)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.first, viewControllers[0])
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.count, 3)
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers[0], viewControllers[1])
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers[1], viewControllers[2])
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers[2], viewControllers[3])

        await perform(.set(nil, for: .secondary))
        XCTAssertEqual(rootViewController.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.first, viewControllers[0])

        await perform(.set(viewControllers[1], for: .secondary))
        XCTAssertEqual(rootViewController.viewControllers.count, 2)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.first, viewControllers[0])
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.first, viewControllers[1])
    }

    func testTripleColumnSetPrimary() async {
        XCTAssertEqual(rootViewController.viewControllers.count, 3)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.first, viewControllers[0])
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.first, viewControllers[1])
        XCTAssertEqual((rootViewController.viewControllers[2] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[2] as? UINavigationController)?.viewControllers.first, viewControllers[2])

        await perform(.set(viewControllers[3], for: .primary))
        XCTAssertEqual(rootViewController.viewControllers.count, 3)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.first, viewControllers[3])
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.first, viewControllers[1])
        XCTAssertEqual((rootViewController.viewControllers[2] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[2] as? UINavigationController)?.viewControllers.first, viewControllers[2])
    }

    func testTripleColumnSetSecondary() async {
        XCTAssertEqual(rootViewController.viewControllers.count, 3)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.first, viewControllers[0])
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.first, viewControllers[1])
        XCTAssertEqual((rootViewController.viewControllers[2] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[2] as? UINavigationController)?.viewControllers.first, viewControllers[2])

        await perform(.set(viewControllers[3], for: .secondary))
        XCTAssertEqual(rootViewController.viewControllers.count, 3)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.first, viewControllers[0])
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.first, viewControllers[1])
        XCTAssertEqual((rootViewController.viewControllers[2] as? UINavigationController)?.viewControllers.count, 2)
        XCTAssertEqual((rootViewController.viewControllers[2] as? UINavigationController)?.viewControllers[0], viewControllers[2])
        XCTAssertEqual((rootViewController.viewControllers[2] as? UINavigationController)?.viewControllers[1], viewControllers[3])
    }

    func testTripleColumnSetSupplementary() async {
        XCTAssertEqual(rootViewController.viewControllers.count, 3)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.first, viewControllers[0])
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.first, viewControllers[1])
        XCTAssertEqual((rootViewController.viewControllers[2] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[2] as? UINavigationController)?.viewControllers.first, viewControllers[2])

        await perform(.set(viewControllers[3], for: .supplementary))
        XCTAssertEqual(rootViewController.viewControllers.count, 3)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[0] as? UINavigationController)?.viewControllers.first, viewControllers[0])
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[1] as? UINavigationController)?.viewControllers.first, viewControllers[3])
        XCTAssertEqual((rootViewController.viewControllers[2] as? UINavigationController)?.viewControllers.count, 1)
        XCTAssertEqual((rootViewController.viewControllers[2] as? UINavigationController)?.viewControllers.first, viewControllers[2])
    }

}
