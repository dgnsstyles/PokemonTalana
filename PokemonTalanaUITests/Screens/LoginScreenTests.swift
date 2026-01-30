//
//  LoginScreenTests.swift
//  PokemonTalanaUITests
//
//  Created by David Goren on 30-01-26.
//

import XCTest

final class LoginScreenTests: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI-Testing"]
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testLoginScreen_DisplaysAllElements() {
        // Given & When - App launches
        
        // Then
        XCTAssertTrue(app.textFields[AccessibilityIdentifiers.loginUsernameField].exists)
        XCTAssertTrue(app.secureTextFields[AccessibilityIdentifiers.loginPasswordField].exists)
        XCTAssertTrue(app.buttons[AccessibilityIdentifiers.loginButton].exists)
        XCTAssertTrue(app.buttons[AccessibilityIdentifiers.registerButton].exists)
    }
    
    func testLoginScreen_EmptyFields_ShowsError() {
        // Given
        let loginButton = app.buttons[AccessibilityIdentifiers.loginButton]
        
        // When
        loginButton.tap()
        
        // Then
        let errorLabel = app.staticTexts[AccessibilityIdentifiers.errorMessage]
        XCTAssertTrue(app.waitForElement(errorLabel))
        XCTAssertEqual(errorLabel.label, "Please enter username and password")
    }
    
    func testLoginScreen_SuccessfulRegistration_NavigatesToPokemonList() {
        // Given
        let uniqueUsername = "user_\(UUID().uuidString.prefix(8))"
        let password = "password123"
        
        // When
        app.register(username: uniqueUsername, password: password)
        
        // Then
        let listTitle = app.staticTexts[AccessibilityIdentifiers.pokemonListTitle]
        XCTAssertTrue(app.waitForElement(listTitle, timeout: 10))
    }
    
    func testLoginScreen_ToggleBetweenLoginAndRegister() {
        // Given
        let toggleButton = app.buttons.element(boundBy: 4) // "Don't have an account? Register" button
        
        // When - Initial is Login mode
        XCTAssertEqual(app.buttons[AccessibilityIdentifiers.loginButton].label, "Login")
        
        // When - Tap toggle
        toggleButton.tap()
        
        // Then - Should be Register mode
        XCTAssertEqual(app.buttons[AccessibilityIdentifiers.registerButton].label, "Register")
    }
}
