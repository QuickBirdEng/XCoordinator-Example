//
//  UITestIdentifiers.swift
//  XCoordinator-Example
//
//  Accessibility identifiers used by the UI test target. If you change a string here, update the
//  matching literal in XCoordinator-ExampleUITests/XCoordinator_ExampleUITests.swift.
//

import Foundation

enum UITestIdentifiers {
    static let loginButton = "login.button"
    static let homeContainerTab = "home-container.tab"
    static let homeContainerSplit = "home-container.split"
    static let homeContainerPage = "home-container.page"
    static let usersButton = "home.users-button"
}

enum UITestLaunchArguments {
    /// `--random-picker-index N` makes the Random picker action deterministic in UI tests:
    /// the AppCoordinator picks `routers[N]` instead of calling `randomElement()`. Absent → real random.
    static let randomPickerIndex = "--random-picker-index"
}
