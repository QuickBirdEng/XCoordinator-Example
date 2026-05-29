//
//  XCoordinator_ExampleUITests.swift
//  XCoordinator-ExampleUITests
//
//  Created by Paul Kraft on 28.08.19.
//  Copyright © 2019 QuickBird Studios. All rights reserved.
//

import XCTest

// String literals below must match those in XCoordinator-Example/Common/UITestIdentifiers.swift.
// The UI-test target is a separate process and can't import the app target, so the constants are
// duplicated; keep them in sync by hand.
private enum ID {
    static let loginButton = "login.button"
    static let homeContainerTab = "home-container.tab"
    static let homeContainerSplit = "home-container.split"
    static let homeContainerPage = "home-container.page"
    static let usersButton = "home.users-button"
    static let randomPickerIndexArg = "--random-picker-index"
}

private enum PickerLabel {
    static let tab = "HomeTabCoordinator"
    static let split = "HomeSplitCoordinator"
    static let page = "HomePageCoordinator"
    static let random = "Random"
}

final class XCoordinator_ExampleUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    // MARK: - Helpers

    private func launch(arguments: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments += arguments
        app.launch()
        return app
    }

    @discardableResult
    private func tapLoginAndWaitForPicker(_ app: XCUIApplication) -> XCUIElement {
        let loginButton = app.buttons[ID.loginButton]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5), "Login button never appeared")
        loginButton.tap()
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Picker alert never appeared")
        return alert
    }

    private func assertContainerVisible(_ identifier: String, in app: XCUIApplication,
                                        file: StaticString = #file, line: UInt = #line) {
        let container = app.descendants(matching: .any).matching(identifier: identifier).firstMatch
        XCTAssertTrue(container.waitForExistence(timeout: 5),
                      "Expected container '\(identifier)' to appear", file: file, line: line)
    }

    // MARK: - Scene delegate / launch

    func testAppLaunchesUnderSceneDelegate() {
        let app = launch()
        XCTAssertTrue(app.buttons[ID.loginButton].waitForExistence(timeout: 5),
                      "App did not launch — SceneDelegate may not be wired up correctly.")
    }

    // MARK: - Picker structure

    func testLoginFlowReachesPicker() {
        let app = launch()
        let alert = tapLoginAndWaitForPicker(app)
        XCTAssertTrue(alert.buttons[PickerLabel.tab].exists)
        XCTAssertTrue(alert.buttons[PickerLabel.split].exists)
        XCTAssertTrue(alert.buttons[PickerLabel.page].exists)
        XCTAssertTrue(alert.buttons[PickerLabel.random].exists)
    }

    // MARK: - Explicit picker choices land on the right container

    func testTabPickerLandsOnTabBar() {
        let app = launch()
        tapLoginAndWaitForPicker(app).buttons[PickerLabel.tab].tap()
        assertContainerVisible(ID.homeContainerTab, in: app)
    }

    func testSplitPickerLandsOnSplit() {
        let app = launch()
        tapLoginAndWaitForPicker(app).buttons[PickerLabel.split].tap()
        assertContainerVisible(ID.homeContainerSplit, in: app)
    }

    func testPagePickerLandsOnPage() {
        let app = launch()
        tapLoginAndWaitForPicker(app).buttons[PickerLabel.page].tap()
        assertContainerVisible(ID.homeContainerPage, in: app)
    }

    // MARK: - Random picker exercises all three containers (regression for the duplicate-entry bug)

    func testRandomPickerIndex0LandsOnTab() {
        let app = launch(arguments: [ID.randomPickerIndexArg, "0"])
        tapLoginAndWaitForPicker(app).buttons[PickerLabel.random].tap()
        assertContainerVisible(ID.homeContainerTab, in: app)
    }

    func testRandomPickerIndex1LandsOnSplit() {
        let app = launch(arguments: [ID.randomPickerIndexArg, "1"])
        tapLoginAndWaitForPicker(app).buttons[PickerLabel.random].tap()
        assertContainerVisible(ID.homeContainerSplit, in: app)
    }

    func testRandomPickerIndex2LandsOnPage() {
        let app = launch(arguments: [ID.randomPickerIndexArg, "2"])
        tapLoginAndWaitForPicker(app).buttons[PickerLabel.random].tap()
        assertContainerVisible(ID.homeContainerPage, in: app)
    }

    // MARK: - URL deep linking

    private func launchWithDeepLink(_ url: String) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchEnvironment["XCOORDINATOR_DEEP_LINK"] = url
        app.launch()
        return app
    }

    func testNewsDeepLinkFromColdLaunch() {
        let app = launchWithDeepLink("xcoordinator-example://news/0")
        // Title label is "Article 0\nStefan" (title + newline + subtitle), so match by prefix.
        let predicate = NSPredicate(format: "label BEGINSWITH 'Article 0'")
        let title = app.staticTexts.matching(predicate).firstMatch
        XCTAssertTrue(title.waitForExistence(timeout: 8),
                      "Expected news detail for article 0 to appear via deep link.")
    }

    func testUsersDeepLink() {
        let app = launchWithDeepLink("xcoordinator-example://users/Paul")
        XCTAssertTrue(app.staticTexts["Paul"].waitForExistence(timeout: 10),
                      "Expected user detail screen for 'Paul' to appear via deep link.")
    }

    func testUnknownURLIsIgnored() {
        let app = launchWithDeepLink("xcoordinator-example://nonsense/whatever")
        XCTAssertTrue(app.buttons[ID.loginButton].waitForExistence(timeout: 5),
                      "App should fall back to the login screen for unrecognised URLs.")
    }

    // MARK: - Peek/pop removal: long-press is now a no-op (used to register a 3D-Touch peek source)

    func testLongPressOnUserListDoesNotCrash() {
        let app = launch()
        tapLoginAndWaitForPicker(app).buttons[PickerLabel.tab].tap()
        assertContainerVisible(ID.homeContainerTab, in: app)

        let users = app.buttons[ID.usersButton]
        XCTAssertTrue(users.waitForExistence(timeout: 5), "Users button never appeared")
        users.tap()

        let firstCell = app.cells.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "User-list cell never appeared")
        firstCell.press(forDuration: 1.2)

        XCTAssertTrue(app.cells.firstMatch.exists, "App appears to have crashed during long-press")
    }
}
