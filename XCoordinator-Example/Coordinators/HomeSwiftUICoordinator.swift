//
//  HomeSwiftUICoordinator.swift
//  XCoordinator-Example
//
//  Copyright © 2026 QuickBird Studios. All rights reserved.
//

import SwiftUI
import XCoordinator

/// Observable state shared between `HomeSwiftUICoordinator` and `HomeSwiftUIView`.
///
/// The selected tab lives here (not in `HomeRoute`, which has no `Hashable` requirement) so the
/// coordinator can mutate it from `prepareTransition` and the SwiftUI `TabView` can bind to it.
@MainActor
final class HomeSwiftUIState: ObservableObject {

    /// Local, `Hashable` tag for the `TabView` selection. Mirrors `HomeRoute`'s two flows.
    enum Tab: Hashable {
        case news
        case userList
    }

    @Published var selection: Tab = .userList
}

/// Home flow rendered as a **SwiftUI** container — the fourth variant alongside `HomeTabCoordinator`,
/// `HomeSplitCoordinator`, and `HomePageCoordinator`, driving the same `HomeRoute`.
///
/// It demonstrates XCoordinator 3's SwiftUI interop in *both* directions:
/// - **UIKit → SwiftUI**: `ViewCoordinator(body:)` hosts `HomeSwiftUIView` in a `RoutingController`
///   and registers `self`, so a `@Routing<HomeRoute>` inside the view resolves to this coordinator.
/// - **SwiftUI → UIKit**: `HomeSwiftUIView` embeds `NewsCoordinator` / `UserListCoordinator` via
///   `WrappedRouter` (see that file).
///
/// `HomeRoute` is handled with `Transition.withAnimation`, mutating the SwiftUI `selection` binding
/// instead of performing a UIKit transition — so triggering `.news` / `.userList` animates the tab.
final class HomeSwiftUICoordinator: ViewCoordinator<HomeRoute> {

    // MARK: Stored properties

    private let state: HomeSwiftUIState

    // MARK: Initialization

    init() {
        // Stored properties must be initialized before `super.init`, and the body closure must not
        // capture `self` (not yet initialized) — so build the state locally and capture that.
        let state = HomeSwiftUIState()
        self.state = state
        super.init(body: { HomeSwiftUIView(state: state) })
    }

    // MARK: Overrides

    override func prepareTransition(for route: HomeRoute) -> ViewTransition {
        // Binding-update route: instead of a UIKit transition, drive the SwiftUI `TabView` selection.
        // `Transition.withAnimation` runs the mutation inside `SwiftUI.withAnimation` and respects the
        // transition's `animated` flag.
        switch route {
        case .news:
            Transition.withAnimation { [state] in state.selection = .news }
        case .userList:
            Transition.withAnimation { [state] in state.selection = .userList }
        }
    }

}
