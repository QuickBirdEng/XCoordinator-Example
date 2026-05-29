//
//  UserCoordinator.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 09.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit
import XCoordinator

/// Routes for the user-detail modal flow.
enum UserRoute: Route {
    /// Push the user-detail screen for the named user. Used as the initial route.
    case user(String)
    /// Present a `UIAlertController` with the given title and message.
    case alert(title: String, message: String)
    /// Dismiss the modal user flow back to the user list.
    case users
    /// Push a screen with a random background colour — the target of the interactive edge-pan gesture.
    case randomColor
}

/// Modal user-detail flow. Demonstrates an interactive (gesture-driven) transition: the edge-pan
/// recognizer registered in `presented(from:)` interactively pushes `.randomColor`.
class UserCoordinator: NavigationCoordinator<UserRoute> {

    // MARK: Initialization

    init(user: String) {
        super.init(initialRoute: .user(user))
    }

    // MARK: Overrides

    override func prepareTransition(for route: UserRoute) -> NavigationTransition {
        switch route {
        case .randomColor:
            let viewController = UIViewController()
            viewController.view.backgroundColor = .random()
            return .push(viewController, animation: .fade)
        case let .user(username):
            let viewController = UserViewController.instantiateFromNib()
            let viewModel = UserViewModelImpl(router: unownedRouter, username: username)
            viewController.bind(to: viewModel)
            return .push(viewController)
        case let .alert(title, message):
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            return .present(alert)
        case .users:
            return .dismiss()
        }
    }

    override func presented(from presentable: Presentable?) {
        super.presented(from: presentable)
        addPushGestureRecognizer(to: rootViewController)
    }

    // MARK: Helpers

    private func addPushGestureRecognizer(to container: Container) {
        let view = container.view
        let gestureRecognizer = UIScreenEdgePanGestureRecognizer()
        gestureRecognizer.edges = .right
        view?.addGestureRecognizer(gestureRecognizer)

        // Interactive-transition wiring: pan progress drives the `.randomColor` push frame-by-frame via
        // XCoordinator's `registerInteractiveTransition`. `progress` reports the gesture's position as a
        // fraction in [0, 1]; `shouldFinish` decides on touch-up whether to complete or cancel.
        registerInteractiveTransition(
            for: .randomColor,
            triggeredBy: gestureRecognizer,
            progress: { [weak view] recognizer in
                let xTranslation = -recognizer.translation(in: view).x
                return max(min(xTranslation / UIScreen.main.bounds.width, 1), 0)
            },
            shouldFinish: { [weak view] recognizer in
                let xTranslation = -recognizer.translation(in: view).x
                let xVelocity = -recognizer.velocity(in: view).x
                return xTranslation >= UIScreen.main.bounds.width / 2
                    || xVelocity >= UIScreen.main.bounds.width / 2
            },
            completion: nil
        )
    }

}

// MARK: - Private extensions

extension UIColor {

    fileprivate static func random(alpha: CGFloat? = 1) -> UIColor {
        return UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: alpha ?? CGFloat.random(in: 0...1)
        )
    }

}
