//
//  TransitionAnimation+Defaults.swift
//  XCoordinator-Example
//
//  Created by Paul Kraft on 28.12.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit
import XCoordinator

/// Shared default used by every custom `Animation` in `Animations/`.
let defaultAnimationDuration: TimeInterval = 0.35

extension CGFloat {
    /// Near-zero value used as a scale factor in transforms. Scaling by exactly `0` produces a non-invertible
    /// matrix and breaks `UIView.animate` interpolation; a small positive number avoids that without being
    /// visually distinguishable from zero.
    static let verySmall: CGFloat = 0.0001
}
