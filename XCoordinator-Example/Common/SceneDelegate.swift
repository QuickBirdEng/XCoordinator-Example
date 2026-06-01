//
//  SceneDelegate.swift
//  XCoordinator-Example
//
//  Copyright © 2026 QuickBird Studios. All rights reserved.
//

import UIKit

/// Owns the app window per scene and bootstraps the routing tree.
/// `AppCoordinator().strongRouter` holds the entire coordinator graph for this scene's lifetime;
/// `setRoot(for:)` installs `AppCoordinator.rootViewController` as the window's `rootViewController`.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let router = AppCoordinator().strongRouter

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        router.setRoot(for: window)

        // Cold-launch deep links arrive via `connectionOptions.urlContexts`. UI tests inject one through
        // the `XCOORDINATOR_DEEP_LINK` env var instead since `launchEnvironment` is the only handle XCUI
        // gives us into the launch.
        //
        // The handler is dispatched to the next runloop so the AppCoordinator's initial `.login` route
        // has finished pushing before we trigger the deep-link chain.
        var coldLaunchURL = connectionOptions.urlContexts.first?.url
        #if DEBUG
        // Test-only hook: UI tests can't reach `connectionOptions`, so they inject a cold-launch deep
        // link via this env var. Gated to DEBUG so it never ships in release builds.
        coldLaunchURL = ProcessInfo.processInfo.environment["XCOORDINATOR_DEEP_LINK"].flatMap(URL.init(string:))
            ?? coldLaunchURL
        #endif
        if let url = coldLaunchURL {
            DispatchQueue.main.async { [weak self] in
                self?.handle(url: url)
            }
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let context = URLContexts.first {
            handle(url: context.url)
        }
    }

    private func handle(url: URL) {
        guard let route = DeepLinkParser.parse(url) else { return }
        router.trigger(route)
    }
}
