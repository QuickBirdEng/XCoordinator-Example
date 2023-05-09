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
        super.init(rootViewController: rootViewController, initialRoute: nil)
        trigger(.home)
    }

    // MARK: Overrides

    @Prepare
    override func prepare(for route: AboutRoute) -> Transition<RootViewController> {
        switch route {
        case .home:
            Push {
                let viewController = AboutViewController()
                let viewModel = AboutViewModelImpl(router: self)
                viewController.bind(to: viewModel)
                return viewController
            }
        case .website:
            Run {
                let url = URL(string: "https://quickbirdstudios.com/")!
                UIApplication.shared.open(url)
            }
        }
    }

    // MARK: Actions

    @objc
    private func openWebsite() {
        trigger(.website)
    }
    
}
