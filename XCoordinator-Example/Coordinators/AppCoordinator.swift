//
//  AppCoordinator.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit
import XCoordinator

/// The top-level routes of the app: login, the chosen home flow, and deep-link entries.
enum AppRoute: Route {
    /// Push the login screen. Used as the initial route.
    case login
    /// Present the home flow. Pass `nil` to show the picker that lets the user choose one of `HomeTabCoordinator`,
    /// `HomeSplitCoordinator`, or `HomePageCoordinator`; pass a concrete router to skip the picker.
    case home((any Router<HomeRoute>)?)
    /// Deep-link into a specific article, tearing down any modal stack and resetting navigation first.
    case newsDetail(News)
    /// Deep-link into a specific user, tearing down any modal stack and resetting navigation first.
    case userDetail(username: String)
}

/// Owns the top-level navigation stack. Entry point from `SceneDelegate`/`AppDelegate`; spawns the chosen
/// home-flow coordinator and handles the simulated deep link into a news article.
class AppCoordinator: NavigationCoordinator<AppRoute> {

    // MARK: Initialization

    init() {
        super.init(initialRoute: .login)
    }

    // MARK: Overrides

    // `@TransitionBuilder` (inherited from `BaseCoordinator.prepareTransition`) lets each case read as a
    // single declarative `Transition` expression with no `return`. View-controller construction is
    // extracted into the helpers below so each case stays a plain expression.
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .login:
            Transition.push(makeLoginViewController())
        case let .home(router):
            homeTransition(for: router)
        case .newsDetail(let news):
            // Deep-link demo: `.multiple` runs the transitions in sequence, and `deepLink(...)` walks down
            // the coordinator hierarchy (AppRoute → HomeRoute → NewsRoute). The leading `.dismissAll()` +
            // `.popToRoot()` guarantee a clean slate wherever the link fires.
            Transition.multiple(.dismissAll(), .popToRoot(),
                                deepLink(AppRoute.home(HomePageCoordinator()),
                                         HomeRoute.news,
                                         NewsRoute.newsDetail(news)))
        case let .userDetail(username):
            // Same deep-link shape as `.newsDetail`, ending in a modal present of the user detail.
            // Targets `HomeRoute.userList`, `HomePageCoordinator`'s initial page — it works because
            // XCoordinator 3's `.set` fires its completion even when the page is already on-screen, so the
            // chain continues instead of stalling.
            Transition.multiple(.dismissAll(), .popToRoot(),
                                deepLink(AppRoute.home(HomePageCoordinator()),
                                         HomeRoute.userList,
                                         UserListRoute.user(username)))
        }
    }

    // MARK: Methods

    /// When a concrete home router is supplied, present it full-screen; otherwise present the picker alert.
    private func homeTransition(for router: (any Router<HomeRoute>)?) -> NavigationTransition {
        if let router {
            return .presentFullScreen(router, animation: .fade)
        } else {
            // No router supplied → present an ad-hoc `UIAlertController` that lets the user pick one of the
            // three home-flow coordinators; the chosen coordinator is re-triggered through `.home(...)`,
            // demonstrating that a `Transition` can present arbitrary decision UI.
            return .present(makeHomePickerAlert())
        }
    }

    private func makeLoginViewController() -> UIViewController {
        let viewController = LoginViewController.instantiateFromNib()
        let viewModel = LoginViewModelImpl(router: self)
        viewController.bind(to: viewModel)
        return viewController
    }

    private func makeHomePickerAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "How would you like to login?",
            message: "Please choose the type of coordinator used for the `Home` scene.",
            preferredStyle: .alert)
        alert.addAction(
            .init(title: "\(HomeTabCoordinator.self)", style: .default) { [unowned self] _ in
                self.trigger(.home(HomeTabCoordinator()))
            }
        )
        alert.addAction(
            .init(title: "\(HomeSplitCoordinator.self)", style: .default) { [unowned self] _ in
                self.trigger(.home(HomeSplitCoordinator()))
            }
        )
        alert.addAction(
            .init(title: "\(HomePageCoordinator.self)", style: .default) { [unowned self] _ in
                self.trigger(.home(HomePageCoordinator()))
            }
        )
        alert.addAction(
            .init(title: "\(HomeSwiftUICoordinator.self)", style: .default) { [unowned self] _ in
                self.trigger(.home(HomeSwiftUICoordinator()))
            }
        )
        alert.addAction(
            .init(title: "Random", style: .default) { [unowned self] _ in
                // `HomeSwiftUICoordinator` is appended last so the UI tests that pass
                // `--random-picker-index 0/1/2` still resolve to Tab/Split/Page respectively.
                let routers: [() -> any Router<HomeRoute>] = [
                    { HomeTabCoordinator() },
                    { HomeSplitCoordinator() },
                    { HomePageCoordinator() },
                    { HomeSwiftUICoordinator() }
                ]
                let factory: (() -> any Router<HomeRoute>)?
                if let index = Self.testRandomPickerIndex, routers.indices.contains(index) {
                    factory = routers[index]
                } else {
                    factory = routers.randomElement()
                }
                self.trigger(.home(factory?()))
            }
        )
        return alert
    }

    /// Returns the index value from `--random-picker-index N` launch argument, if present and parseable.
    /// Used by UI tests to make the Random picker deterministic; nil in normal runs.
    private static var testRandomPickerIndex: Int? {
        let args = ProcessInfo.processInfo.arguments
        guard let position = args.firstIndex(of: UITestLaunchArguments.randomPickerIndex),
              position + 1 < args.count else {
            return nil
        }
        return Int(args[position + 1])
    }

}
