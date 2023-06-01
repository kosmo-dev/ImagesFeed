//
//  ImagesFeedUITests.swift
//  ImagesFeedUITests
//
//  Created by Вадим Кузьмин on 31.05.2023.
//

@testable import ImagesFeed
import XCTest

final class ImagesFeedUITests: XCTestCase {
    let email = ""
    let password = ""
    let fullname = ""
    let username = ""

    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false

        app.launch()
    }

    func testAuth() throws {
        app.buttons["Authenticate"].tap()

        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText(email)
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText(password)

        let loginButton = webView.descendants(matching: .button).element
        loginButton.tap()

        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }

    func testFeed() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        sleep(3)

        cell.swipeUp()

        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        cellToLike.buttons["Like"].tap()
        sleep(2)
        cellToLike.buttons["Like"].tap()
        sleep(2)

        cellToLike.tap()
        sleep(10)

        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)

        app.buttons["NavigationBackButton"].tap()

    }

    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()

        XCTAssertTrue(app.staticTexts[fullname].exists)
        XCTAssertTrue(app.staticTexts[username].exists)

        app.buttons["Logout"].tap()

        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()

        sleep(1)
        XCTAssertTrue(app.staticTexts["Войти"].exists)
    }
}
