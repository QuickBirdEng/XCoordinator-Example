//
//  AppDelegate.swift
//  XCoordinator-Example
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit
import XCoordinator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Stored properties

    private lazy var mainWindow = UIWindow()
    private let router = AppCoordinator().strongRouter

    // MARK: UIApplicationDelegate

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureUI()
        router.setRoot(for: mainWindow)
        return true
    }

    // MARK: Helpers

    private func configureUI() {
        UIView.appearance().overrideUserInterfaceStyle = .light
    }

}
