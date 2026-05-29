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
    case home(StrongRouter<HomeRoute>?)
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

    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .login:
            let viewController = LoginViewController.instantiateFromNib()
            let viewModel = LoginViewModelImpl(router: unownedRouter)
            viewController.bind(to: viewModel)
            return .push(viewController)
        case let .home(router):
            if let router = router {
                return .presentFullScreen(router, animation: .fade)
            }
            // Teaching device: when no router is supplied, the route itself resolves to a `UIAlertController`
            // that lets the user pick one of the three home-flow coordinators. The chosen coordinator's
            // router is then re-triggered through `.home(...)`, demonstrating that a `Transition` can be
            // anything you can `.present`, including ad-hoc decision UI.
            let alert = UIAlertController(
                title: "How would you like to login?",
                message: "Please choose the type of coordinator used for the `Home` scene.",
                preferredStyle: .alert)
            alert.addAction(
                .init(title: "\(HomeTabCoordinator.self)", style: .default) { [unowned self] _ in
                    self.trigger(.home(HomeTabCoordinator().strongRouter))
                }
            )
            alert.addAction(
                .init(title: "\(HomeSplitCoordinator.self)", style: .default) { [unowned self] _ in
                    self.trigger(.home(HomeSplitCoordinator().strongRouter))
                }
            )
            alert.addAction(
                .init(title: "\(HomePageCoordinator.self)", style: .default) { [unowned self] _ in
                    self.trigger(.home(HomePageCoordinator().strongRouter))
                }
            )
            alert.addAction(
                .init(title: "Random", style: .default) { [unowned self] _ in
                    let routers: [() -> StrongRouter<HomeRoute>] = [
                        { HomeTabCoordinator().strongRouter },
                        { HomeSplitCoordinator().strongRouter },
                        { HomePageCoordinator().strongRouter }
                    ]
                    let factory: (() -> StrongRouter<HomeRoute>)?
                    if let index = Self.testRandomPickerIndex, routers.indices.contains(index) {
                        factory = routers[index]
                    } else {
                        factory = routers.randomElement()
                    }
                    self.trigger(.home(factory?()))
                }
            )
            return .present(alert)
        case .newsDetail(let news):
            // Deep-link demo: `.multiple` chains transitions in sequence, and `deepLink(...)` walks down the
            // coordinator hierarchy by triggering successive routes (AppRoute → HomeRoute → NewsRoute).
            // The leading `.dismissAll()` + `.popToRoot()` guarantee a clean slate regardless of where in
            // the navigation tree the user happens to be when the link fires.
            return .multiple(
                .dismissAll(),
                .popToRoot(),
                deepLink(AppRoute.home(HomePageCoordinator().strongRouter),
                         HomeRoute.news,
                         NewsRoute.newsDetail(news))
            )
        case let .userDetail(username):
            // Same deep-link shape as `.newsDetail`, ending in a modal present of the user detail.
            // Note this targets `HomeRoute.userList`, which is `HomePageCoordinator`'s initial page —
            // it works because `HomePageCoordinator` uses `setReliably` (see Extensions/Transitions.swift),
            // which fires the transition completion even when the page is already on-screen, so the chain
            // continues to `UserListRoute.user` instead of stalling.
            return .multiple(
                .dismissAll(),
                .popToRoot(),
                deepLink(AppRoute.home(HomePageCoordinator().strongRouter),
                         HomeRoute.userList,
                         UserListRoute.user(username))
            )
        }
    }

    // MARK: Methods

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
