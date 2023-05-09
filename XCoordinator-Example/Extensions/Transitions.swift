//
//  Transitions.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 17.09.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import UIKit
import XCoordinator

struct DismissAll<RootViewController> {
    init() {}
}

extension DismissAll: TransitionComponent where RootViewController: UIViewController {
    func build() -> Transition<RootViewController> {
        Transition(presentables: [], animationInUse: nil) { rootViewController, options, completion in
            guard let presentedViewController = rootViewController.presentedViewController else {
                completion?()
                return
            }
            presentedViewController.dismiss(animated: options.animated) {
                Transition { DismissAll() }
                    .perform(on: rootViewController, with: options, completion: completion)
            }
        }
    }
}
