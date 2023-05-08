//
//  CoordinatorTestCase.swift
//  XCoordinator-ExampleTests
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

import XCTest
import XCoordinator
@testable import XCoordinator_Example

@MainActor
class CoordinatorTestCase<CoordinatorType: Coordinator>: XCTestCase where CoordinatorType.RouteType == TestRoute<CoordinatorType.TransitionType> {

    // MARK: Nested Types

    enum AnimationType {
        case presentation
        case dismissal
    }

    // MARK: Computed Properties

    var availableWindows: [UIWindow] {
        UIApplication.shared.connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
    }

    var appDelegate: AppDelegate! {
        UIApplication.shared.delegate as? AppDelegate
    }

    var window: UIWindow! {
        availableWindows.first { $0.isKeyWindow } ?? availableWindows.first
    }

    var rootViewController: CoordinatorType.RootViewController! {
        coordinator?.rootViewController
    }

    // MARK: Stored Properties

    private(set) var coordinator: CoordinatorType!
    private(set) var viewControllers = [UIViewController]()

    // MARK: Overrides

    override func setUp() async throws {
        try await super.setUp()

        coordinator = try createCoordinator()
        coordinator.setRoot(for: window)
        sleepAsync(for: 2)
    }

    // MARK: Methods

    func createCoordinator() throws -> CoordinatorType {
        fatalError(#function + " must be overwritten.")
    }

    func createViewControllers(count: Int) {
        let colors: [UIColor] = [.red, .blue, .green, .brown, .magenta, .yellow, .gray, .orange]

        viewControllers = (0..<count).map { index in
            TestViewController(color: colors[index % colors.count], text: index.description)
        }
    }

    func sleepAsync(for timeInterval: TimeInterval) {
        let expectation = makeExpectation()
        DispatchQueue.global().asyncAfter(deadline: .now() + timeInterval) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeInterval + 1)
    }

    func perform(_ transition: CoordinatorType.TransitionType, animated: Bool = true) async {
        await coordinator.trigger(.perform(transition), with: .init(animated: animated))
    }

    nonisolated func performWithAnimation(
        interactive: Bool = false,
        animated: Bool = true,
        isPresenting: Bool = true,
        timeout: TimeInterval = 1,
        _ makeTransition: (Animation) throws -> CoordinatorType.TransitionType
    ) async rethrows {
        let animationExpectation = await makeExpectation("Animation")
        let noAnimationExpectation = await makeExpectation("NoAnimation")
        noAnimationExpectation.isInverted = true
        let completionExpectation = await makeExpectation("Completion")
        let presentationExpectation = isPresenting ? animationExpectation : noAnimationExpectation
        let dismissalExpectation = isPresenting ? noAnimationExpectation : animationExpectation
        let animation = interactive
        ? Animation.interactive(presentation: presentationExpectation, dismissal: dismissalExpectation)
        : Animation.static(presentation: presentationExpectation, dismissal: dismissalExpectation)
        let transition = try makeTransition(animation)
        Task { @MainActor [self] in
            coordinator.trigger(.perform(transition), with: .init(animated: animated)) {
                completionExpectation.fulfill()
                _ = animation
            }
        }

        try? await Task.sleep(nanoseconds: 100 * NSEC_PER_MSEC)
        await fulfillment(of: [animationExpectation, noAnimationExpectation, completionExpectation], timeout: timeout, enforceOrder: true)
    }

    func makeController(_ text: String, color: UIColor = .systemBackground) -> UIViewController {
        TestViewController(color: color, text: text)
    }

    func makeExpectation(_ name: String = String(), function: String = #function) -> XCTestExpectation {
        let name = function + " - " + (name.isEmpty ? "" : name + " - ")
        return expectation(description: name + UUID().uuidString)
    }

}
