//
//  Animation+Navigation.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 18.01.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import UIKit
import XCoordinator

// swiftlint:disable force_unwrapping

extension Animation {
    /// Custom navigation push/pop: slides horizontally with a parallax-style 30%-width offset on the
    /// outgoing view, mimicking the default `UINavigationController` push.
    static let navigation = Animation(presentation: InteractiveTransitionAnimation.push,
                                      dismissal: InteractiveTransitionAnimation.pop)
}

extension InteractiveTransitionAnimation {
    private static let duration: TimeInterval = 0.25

    fileprivate static let push = InteractiveTransitionAnimation(duration: duration) { context in
        let toView = context.view(forKey: .to)!
        let fromView = context.view(forKey: .from)!

        // The on-screen frame is the incoming view's final frame (a custom animator owns layout; a
        // `UIHostingController` without a frame renders blank — see Animation+Fade).
        let middleFrame = context.viewController(forKey: .to).map(context.finalFrame(for:)) ?? fromView.frame

        var leftFrame = middleFrame
        leftFrame.origin.x -= middleFrame.width * 0.3

        var rightFrame = middleFrame
        rightFrame.origin.x += middleFrame.width

        toView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        context.containerView.addSubview(toView)
        context.containerView.bringSubviewToFront(toView)
        toView.frame = rightFrame

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            fromView.frame = leftFrame
            toView.frame = middleFrame
        }, completion: { _ in
            context.completeTransition(!context.transitionWasCancelled)
        })
    }

    fileprivate static let pop = InteractiveTransitionAnimation(duration: duration) { context in
        let toView = context.view(forKey: .to)!
        let fromView = context.view(forKey: .from)!

        let middleFrame = context.viewController(forKey: .to).map(context.finalFrame(for:)) ?? fromView.frame

        var leftFrame = middleFrame
        leftFrame.origin.x -= middleFrame.width * 0.3

        var rightFrame = middleFrame
        rightFrame.origin.x += middleFrame.width

        toView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        context.containerView.addSubview(toView)
        context.containerView.sendSubviewToBack(toView)
        toView.frame = leftFrame

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            fromView.frame = rightFrame
            toView.frame = middleFrame
        }, completion: { _ in
            context.completeTransition(!context.transitionWasCancelled)
        })
    }
}
