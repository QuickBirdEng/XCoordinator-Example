//
//  Transitions.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 17.09.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import UIKit
import XCoordinator

extension Transition {

    /// Wraps `.present` but forces `modalPresentationStyle = .fullScreen` first. Avoids the iOS 13+ sheet
    /// presentation default for cases (like login → home) where the parent should be fully covered.
    static func presentFullScreen(_ presentable: Presentable, animation: Animation? = nil) -> Transition {
        presentable.viewController?.modalPresentationStyle = .fullScreen
        return .present(presentable, animation: animation)
    }

    /// Walks the entire modal-presentation chain rooted at `rootViewController` and dismisses each
    /// presented controller in order. Terminates when `rootViewController.presentedViewController` is `nil`
    /// — each dismissal removes one level from the chain, so the recursion is bounded by the modal depth.
    static func dismissAll() -> Transition {
        return Transition(presentables: [], animationInUse: nil) { rootViewController, options, completion in
            guard let presentedViewController = rootViewController.presentedViewController else {
                completion?()
                return
            }
            presentedViewController.dismiss(animated: options.animated) {
                Transition.dismissAll()
                    .perform(on: rootViewController, with: options, completion: completion)
            }
        }
    }

}
