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

extension Transition where RootViewController: UIPageViewController {

    /// A drop-in replacement for the stock `PageTransition.set(_:direction:)` that **always** calls its
    /// completion handler.
    ///
    /// `UIPageViewController.setViewControllers(_:direction:animated:completion:)` silently skips its
    /// completion block when the requested page is already the one on-screen (a long-standing UIKit quirk).
    /// `deepLink` chains the next route *inside* a transition's completion, so a deep link whose page step
    /// targets the already-visible page would stall forever. This variant short-circuits the no-op case and
    /// invokes the completion directly, so deep links (and any chained `.multiple`) keep flowing.
    static func setReliably(_ presentable: Presentable,
                            direction: UIPageViewController.NavigationDirection) -> Transition {
        Transition(presentables: [presentable], animationInUse: nil) { rootViewController, options, completion in
            guard let target = presentable.viewController else {
                completion?()
                return
            }
            let isAlreadyVisible = rootViewController.viewControllers?.count == 1
                && rootViewController.viewControllers?.first === target
            guard !isAlreadyVisible else {
                // The page is already displayed — UIKit would not call the completion, so do it ourselves.
                // `presented(from:)` was already invoked when this page was first set, so it is not repeated.
                completion?()
                return
            }
            rootViewController.setViewControllers([target], direction: direction, animated: options.animated) { _ in
                presentable.presented(from: rootViewController)
                completion?()
            }
        }
    }

}
