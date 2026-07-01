//
//  HomeSwiftUIView.swift
//  XCoordinator-Example
//
//  Copyright © 2026 QuickBird Studios. All rights reserved.
//

import SwiftUI
import XCoordinator

/// The SwiftUI body of `HomeSwiftUICoordinator`. Demonstrates the **SwiftUI → UIKit** direction:
/// each tab hosts a UIKit coordinator sub-flow via `WrappedRouter`. Tab selection is routed through
/// `@Routing<HomeRoute>` (the **forward**, in-SwiftUI routing direction), which the coordinator turns
/// into an animated `selection` change via `Transition.withAnimation`.
struct HomeSwiftUIView: View {

    // MARK: Properties

    @ObservedObject var state: HomeSwiftUIState

    /// Resolves to the hosting `HomeSwiftUICoordinator` (registered by `ViewCoordinator(body:)`).
    @Routing<HomeRoute> private var router

    // MARK: Body

    var body: some View {
        TabView(selection: routerDrivenSelection) {
            WrappedRouter { UserListCoordinator() }
                .ignoresSafeArea()
                .tabItem { Label("Users", systemImage: "person.2.fill") }
                .tag(HomeSwiftUIState.Tab.userList)

            WrappedRouter { NewsCoordinator() }
                .ignoresSafeArea()
                .tabItem { Label("News", systemImage: "newspaper.fill") }
                .tag(HomeSwiftUIState.Tab.news)
        }
    }

    // MARK: Helpers

    /// A binding whose setter routes through the coordinator instead of mutating state directly:
    /// tapping a tab calls `@Routing` → `router.trigger(...)` →
    /// `HomeSwiftUICoordinator.prepareTransition` → `Transition.withAnimation { state.selection = … }`.
    private var routerDrivenSelection: Binding<HomeSwiftUIState.Tab> {
        Binding(
            get: { state.selection },
            set: { tab in
                router.trigger(tab == .news ? .news : .userList)
            }
        )
    }

}
