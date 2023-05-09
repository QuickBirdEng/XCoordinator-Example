//
//  UserCoordinator.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 09.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit
import XCoordinator

enum UserRoute: Route {
    case user(String)
    case alert(title: String, message: String)
    case users
    case randomColor
}

class UserCoordinator: NavigationCoordinator<UserRoute> {

    // MARK: Initialization

    init(user: String) {
        super.init(initialRoute: .user(user))
    }

    // MARK: Overrides

    @Prepare
    override func prepare(for route: UserRoute) -> Transition<RootViewController> {
        switch route {
        case .randomColor:
            Push(animation: .fade) {
                let viewController = UIViewController()
                viewController.view.backgroundColor = .random()
                return viewController
            }
        case let .user(username):
            Push {
                let viewController = UserViewController.instantiateFromNib()
                let viewModel = UserViewModelImpl(router: self, username: username)
                viewController.bind(to: viewModel)
                return viewController
            }
        case let .alert(title, message):
            Present {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                return alert
            }
        case .users:
            Dismiss()
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
