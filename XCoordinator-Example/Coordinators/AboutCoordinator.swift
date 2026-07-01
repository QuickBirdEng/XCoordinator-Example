//
//  AboutCoordinator.swift
//  XCoordinator-Example
//
//  Created by denis on 29/05/2019.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import UIKit
import XCoordinator

/// Routes for the About flow.
enum AboutRoute: Route {
    /// Push the About screen. Used as the initial route.
    case home
    /// Open the QuickBird Studios website in the system browser (no view-controller transition).
    case website
}

/// About flow attached as a child to `UserListCoordinator`. Reuses the parent's navigation controller
/// (passed via `init(rootViewController:)`) — see `UserListCoordinator.prepareTransition` for the
/// `addChild + .none()` pattern that makes this work.
class AboutCoordinator: NavigationCoordinator<AboutRoute> {
    
    // MARK: Initialization
    
    init(rootViewController: UINavigationController) {
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.home)
    }

    // MARK: Overrides
    
    override func prepareTransition(for route: AboutRoute) -> NavigationTransition {
        switch route {
        case .home:
            Transition.push(makeAboutViewController())
        case .website:
            openWebsiteTransition()
        }
    }

    // MARK: Helpers

    private func makeAboutViewController() -> UIViewController {
        let viewController = AboutViewController()
        let viewModel = AboutViewModelImpl(router: self)
        viewController.bind(to: viewModel)
        return viewController
    }

    /// Custom side-effecting `Transition`: there is no view controller to present, but the route still
    /// needs to flow through the coordinator. Passing `presentables: []` and a closure that opens the URL
    /// externally lets the routing pipeline drive arbitrary work.
    private func openWebsiteTransition() -> NavigationTransition {
        let url = URL(string: "https://quickbirdstudios.com/")!
        return Transition(presentables: [], animationInUse: nil) { _, _, completion in
            UIApplication.shared.open(url)
            completion?()
        }
    }

}
