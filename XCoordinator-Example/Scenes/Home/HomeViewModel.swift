//  
//  HomeViewModel.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 04.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Action
import RxSwift
import XCoordinator

// MARK: - The Input/Output/composite ViewModel pattern (used by every scene in this app)
//
// Each scene defines three protocols:
//   * `<Scene>ViewModelInput`  — RxSwift `AnyObserver` triggers the view controller pushes events into.
//   * `<Scene>ViewModelOutput` — observables the view controller binds to UI.
//   * `<Scene>ViewModel`       — exposes `input` and `output` so view controllers don't see the impl.
//
// A single concrete `<Scene>ViewModelImpl` adopts all three. The `where Self: Input & Output` extension
// below lets that impl satisfy the composite protocol by returning `self` from `input` and `output`,
// so there's no boilerplate forwarding. This pattern is repeated identically across every scene; the
// comment lives here so it's documented once.

protocol HomeViewModelInput {
    var logoutTrigger: AnyObserver<Void> { get }
    var usersTrigger: AnyObserver<Void> { get }
    var aboutTrigger: AnyObserver<Void> { get }
}

protocol HomeViewModelOutput {}

protocol HomeViewModel {
    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }
}

extension HomeViewModel where Self: HomeViewModelInput & HomeViewModelOutput {
    var input: HomeViewModelInput { return self }
    var output: HomeViewModelOutput { return self }
}
