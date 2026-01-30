//
//  PokemonDetailScreenTests.swift
//  PokemonTalanaUITests
//
//  Created by David Goren on 30-01-26.
//

import XCTest

final class PokemonDetailScreenTests: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI-Testing"]
        app.launch()
        
        // Register and login and navigate
        let uniqueUsername = "detail_\(UUID().uuidString.prefix(8))"
        app.register(username: uniqueUsername, password: "password")
        app.tapPokemonCard(id: 1)
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testPokemonDetail_DisplaysBackButton() {
        XCTAssertTrue(app.buttons[AccessibilityIdentifiers.backButton].exists)
    }
    
    func testPokemonDetail_DisplaysPokemonName() {
        let nameLabel = app.staticTexts[AccessibilityIdentifiers.pokemonDetailName]
        XCTAssertTrue(app.waitForElement(nameLabel))
        XCTAssertEqual(nameLabel.label, "Bulbasaur") // UI usually capitalizes
    }
    
    func testPokemonDetail_DisplaysSections() {
        XCTAssertTrue(app.staticTexts["About"].exists)
        XCTAssertTrue(app.staticTexts["Base Stats"].exists)
        XCTAssertTrue(app.staticTexts["Abilities"].exists)
    }
    
    func testPokemonDetail_BackButton_ReturnsToList() {
        // When
        app.buttons[AccessibilityIdentifiers.backButton].tap()
        
        // Then
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.pokemonListTitle].exists)
    }
    
    func testPokemonDetail_FavoriteButton_Exists() {
        XCTAssertTrue(app.buttons[AccessibilityIdentifiers.favoriteStarButton].exists)
    }
}
