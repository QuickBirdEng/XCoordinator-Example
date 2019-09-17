//
//  AboutCoordinator.swift
//  XCoordinator-Example
//
//  Created by denis on 29/05/2019.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import UIKit
import XCoordinator

enum AboutRoute: Route {
    case home
    case website
}

class AboutCoordinator: NavigationCoordinator<AboutRoute> {
    
    // MARK: Initialization
    
    init(rootViewController: UINavigationController) {
        super.init(rootViewController: rootViewController, initialRoute: .home)
    }

    // MARK: Overrides
    
    override func prepareTransition(for route: AboutRoute) -> NavigationTransition {
        switch route {
        case .home:
            let viewController = AboutViewController()
            let viewModel = AboutViewModelImpl(router: unownedRouter)
            viewController.bind(to: viewModel)
            return .push(viewController, animation: .navigation)
        case .website:
            let url = URL(string: "https://quickbirdstudios.com/")!
            return Transition(presentables: [], animationInUse: nil) { _, _, completion in
                UIApplication.shared.open(url)
                completion?()
            }
        }
    }

    // MARK: Actions

    @objc
    private func openWebsite() {
        trigger(.website)
    }
    
}
