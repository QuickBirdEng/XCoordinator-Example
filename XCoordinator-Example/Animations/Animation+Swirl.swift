//
//  Animation+Swirl.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 28.12.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit
import XCoordinator

extension Animation {

    /// Spin-and-grow transition built on `UIViewPropertyAnimator` (hence interruptible). Used for the
    /// news-list → news-detail push.
    static let swirl = Animation(presentation: InterruptibleTransitionAnimation.swirlPresentation,
                                 dismissal: InterruptibleTransitionAnimation.swirlDismissal)
}

extension InterruptibleTransitionAnimation {
    fileprivate static let swirlPresentation = InterruptibleTransitionAnimation(duration: defaultAnimationDuration) { transitionContext in
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!

        // Set the incoming view's final frame before applying any transform. A custom animator owns
        // layout, and a `UIHostingController`'s view with no frame renders blank. (See Animation+Fade.)
        if let toViewController = transitionContext.viewController(forKey: .to) {
            toView.frame = transitionContext.finalFrame(for: toViewController)
        }
        toView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        containerView.backgroundColor = .white
        toView.transform = CGAffineTransform(scaleX: .verySmall, y: .verySmall)
        toView.alpha = 0

        containerView.addSubview(toView)
        containerView.bringSubviewToFront(toView)

        let animator = UIViewPropertyAnimator(duration: defaultAnimationDuration, curve: .easeInOut) {
            toView.transform = .identity
            toView.transform.rotate(by: .pi - .verySmall)
            toView.transform.rotate(by: .pi - .verySmall)

            toView.alpha = 1
            fromView.alpha = 0
        }

        animator.addCompletion { _ in
            fromView.alpha = 1
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        return animator
    }

    fileprivate static let swirlDismissal = InterruptibleTransitionAnimation(duration: defaultAnimationDuration) { transitionContext in
        let containerView: UIView = transitionContext.containerView
        let toView: UIView = transitionContext.view(forKey: .to)!
        let fromView: UIView = transitionContext.view(forKey: .from)!

        if let toViewController = transitionContext.viewController(forKey: .to) {
            toView.frame = transitionContext.finalFrame(for: toViewController)
        }
        toView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        containerView.backgroundColor = .white
        containerView.addSubview(toView)
        containerView.sendSubviewToBack(toView)

        toView.alpha = 0

        let animator = UIViewPropertyAnimator(duration: defaultAnimationDuration, curve: .easeInOut) {
            fromView.transform.scale(by: .verySmall)
            fromView.transform.rotate(by: -.pi + .verySmall)
            fromView.transform.rotate(by: -.pi + .verySmall)

            toView.alpha = 1
            fromView.alpha = 0
        }

        animator.addCompletion { _ in
            if !transitionContext.transitionWasCancelled {
                fromView.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        return animator
    }
}
