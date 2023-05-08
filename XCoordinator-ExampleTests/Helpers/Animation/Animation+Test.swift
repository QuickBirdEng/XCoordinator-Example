//
//  Animation+Test.swift
//  XCoordinator-ExampleTests
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

import XCTest
import XCoordinator
@testable import XCoordinator_Example

extension Animation {

    private static let defaultDuration: TimeInterval = 0.1

    static func `static`(
        presentation presentationExpectation: XCTestExpectation?,
        dismissal dismissalExpectation: XCTestExpectation?,
        duration: TimeInterval = defaultDuration
    ) -> Animation {
        Animation(
            presentation: StaticTransitionAnimation(duration: duration) {
                presentationExpectation?.fulfill()
                $0.fade(duration: duration)
            },
            dismissal: StaticTransitionAnimation(duration: duration) {
                dismissalExpectation?.fulfill()
                $0.fade(duration: duration)
            }
        )
    }

    static func interactive(
        presentation presentationExpectation: XCTestExpectation?,
        dismissal dismissalExpectation: XCTestExpectation?,
        duration: TimeInterval = defaultDuration
    ) -> Animation {
        Animation(
            presentation: InteractiveTransitionAnimation(duration: duration) {
                presentationExpectation?.fulfill()
                $0.fade(duration: duration)
            },
            dismissal: InteractiveTransitionAnimation(duration: duration) {
                dismissalExpectation?.fulfill()
                $0.fade(duration: duration)
            }
        )
    }

}

extension UIViewControllerContextTransitioning {

    fileprivate func fade(duration: TimeInterval) {
        let toView = view(forKey: .to)

        if let toView {
            toView.alpha = 0.0
            containerView.addSubview(toView)
        }

        UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear]) {
            toView?.alpha = 1.0
        } completion: { [self] _ in
            completeTransition(!transitionWasCancelled)
        }
    }

}

import UIKit
import SwiftUI

public class RouterEnvironmentContext {

    private weak var presentable: (any Presentable & AnyObject)?

    internal func inject(_ presentable: any Presentable & AnyObject) {
        self.presentable = presentable
    }



}

private enum RouterContextEnvironmentKey: EnvironmentKey {
    static var defaultValue: RouterEnvironmentContext { RouterEnvironmentContext() }
}

extension EnvironmentValues {

    public var router: RouterEnvironmentContext {
        get { self[RouterContextEnvironmentKey.self] }
        set { self[RouterContextEnvironmentKey.self] = newValue }
    }

}

public struct RouterContextWrapper<Content: View>: View {

    let content: () -> Content
    fileprivate let context: RouterEnvironmentContext

    public var body: some View {
        content().environment(\.router, context)
    }

}

public class RouterHostingController<Content: View>: UIHostingController<RouterContextWrapper<Content>> {

    func inject(router: any Presentable & AnyObject) {

    }

}
