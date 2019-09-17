//
//  AboutCoordinator.swift
//  XCoordinator_Example
//
//  Created by denis on 29/05/2019.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import UIKit
import XCoordinator

enum AboutRoute: Route {
    
}

class AboutCoordinator: NavigationCoordinator<AboutRoute> {
    
    // MARK: Initialization
    
    init(rootViewController: UINavigationController) {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .green
        super.init(rootViewController: rootViewController, root: viewController)
    }

    // MARK: Overrides
    
    override func prepareTransition(for route: AboutRoute) -> NavigationTransition {}
    
}
