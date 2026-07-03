//
//  Animation+Fade.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 28.12.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit
import XCoordinator

extension Animation {
    /// Cross-fade between view controllers. Used for the login → home presentation.
    static let fade = Animation(
        presentation: InteractiveTransitionAnimation.fade,
        dismissal: InteractiveTransitionAnimation.fade
    )
}

extension InteractiveTransitionAnimation {
    fileprivate static let fade = InteractiveTransitionAnimation(duration: defaultAnimationDuration) { transitionContext in
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!

        // Give the incoming view its final frame before animating. UIKit does not pre-size the
        // presented view when a custom animator drives the transition, and a `UIHostingController`
        // whose view has no frame lays out to zero size and renders blank. Setting the final frame
        // (plus autoresizing) keeps the fade working for UIKit *and* SwiftUI-hosted view controllers.
        if let toViewController = transitionContext.viewController(forKey: .to) {
            toView.frame = transitionContext.finalFrame(for: toViewController)
        }
        toView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        toView.alpha = 0.0
        containerView.addSubview(toView)

        UIView.animate(withDuration: defaultAnimationDuration, delay: 0, options: [.curveLinear], animations: {
            toView.alpha = 1.0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
