//
//  Animation+Modal.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 19.01.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import UIKit
import XCoordinator

extension Animation {
    /// Bottom-sheet style: incoming view slides up from below, dismissal slides back down.
    static let modal = Animation(presentation: InteractiveTransitionAnimation.modalPresentation,
                                 dismissal: InteractiveTransitionAnimation.modalDismissal)
}

extension InteractiveTransitionAnimation {
    private static let duration: TimeInterval = 0.35

    fileprivate static let modalPresentation = InteractiveTransitionAnimation(duration: duration) { context in
        let toView: UIView = context.view(forKey: .to)!
        let fromView: UIView = context.view(forKey: .from)!

        // Drive the incoming view from its final frame (a custom animator owns layout; a
        // `UIHostingController` without a frame renders blank — see Animation+Fade).
        let finalFrame = context.viewController(forKey: .to).map(context.finalFrame(for:)) ?? fromView.frame
        var startToFrame = finalFrame
        startToFrame.origin.y += startToFrame.height
        toView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        context.containerView.addSubview(toView)
        context.containerView.bringSubviewToFront(toView)
        toView.frame = startToFrame

        UIView.animate(withDuration: duration, animations: {
            toView.frame = finalFrame
        }, completion: { _ in
            context.completeTransition(!context.transitionWasCancelled)
        })
    }

    fileprivate static let modalDismissal = InteractiveTransitionAnimation(duration: duration) { context in
        let toView: UIView = context.view(forKey: .to)!
        let fromView: UIView = context.view(forKey: .from)!

        let finalFrame = context.viewController(forKey: .to).map(context.finalFrame(for:)) ?? toView.frame
        toView.frame = finalFrame
        toView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        context.containerView.addSubview(toView)
        context.containerView.sendSubviewToBack(toView)
        var newFromFrame = finalFrame
        newFromFrame.origin.y += finalFrame.height

        UIView.animate(withDuration: duration, animations: {
            fromView.frame = newFromFrame
        }, completion: { _ in
            context.completeTransition(!context.transitionWasCancelled)
        })
    }
}
