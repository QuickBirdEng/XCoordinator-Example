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

        var startToFrame = fromView.frame
        startToFrame.origin.y += startToFrame.height
        context.containerView.addSubview(toView)
        context.containerView.bringSubviewToFront(toView)
        toView.frame = startToFrame

        UIView.animate(withDuration: duration, animations: {
            toView.frame = fromView.frame
        }, completion: { _ in
            context.completeTransition(!context.transitionWasCancelled)
        })
    }

    fileprivate static let modalDismissal = InteractiveTransitionAnimation(duration: duration) { context in
        let toView: UIView = context.view(forKey: .to)!
        let fromView: UIView = context.view(forKey: .from)!

        context.containerView.addSubview(toView)
        context.containerView.sendSubviewToBack(toView)
        var newFromFrame = toView.frame
        newFromFrame.origin.y += toView.frame.height

        UIView.animate(withDuration: duration, animations: {
            fromView.frame = newFromFrame
        }, completion: { _ in
            context.completeTransition(!context.transitionWasCancelled)
        })
    }
}
