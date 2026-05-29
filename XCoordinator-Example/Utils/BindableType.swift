//
//  BindableType.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation
import UIKit

/// The MVVM-C binding contract used by every scene in this app. A coordinator instantiates the view
/// controller (typically via `instantiateFromNib()`), then calls `bind(to:)` on it — that assigns the
/// view-model, forces the view hierarchy to load, and invokes `bindViewModel()` so the controller can
/// wire its `IBOutlet`s to the model's `input`/`output` streams via RxSwift.
protocol BindableType: AnyObject {
    associatedtype ViewModelType

    var viewModel: ViewModelType! { get set }

    /// Override to wire the view controller's controls to `viewModel.input` and its outputs to UI elements.
    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    func bind(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}

extension BindableType where Self: UITableViewCell {
    func bind(to model: Self.ViewModelType) {
        viewModel = model
        bindViewModel()
    }
}

extension BindableType where Self: UICollectionViewCell {
    func bind(to model: Self.ViewModelType) {
        viewModel = model
        bindViewModel()
    }
}
