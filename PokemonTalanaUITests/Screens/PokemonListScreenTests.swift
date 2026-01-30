//
//  PokemonListScreenTests.swift
//  PokemonTalanaUITests
//
//  Created by David Goren on 30-01-26.
//

import XCTest

final class PokemonListScreenTests: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI-Testing"]
        app.launch()
        
        // Register and login before each test
        let uniqueUsername = "list_\(UUID().uuidString.prefix(8))"
        app.register(username: uniqueUsername, password: "password")
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testPokemonList_DisplaysTitle() {
        // Then
        let title = app.staticTexts[AccessibilityIdentifiers.pokemonListTitle]
        XCTAssertTrue(app.waitForElement(title))
    }
    
    func testPokemonList_DisplaysSearchBar() {
        // Then
        XCTAssertTrue(app.textFields[AccessibilityIdentifiers.searchField].exists)
    }
    
    func testPokemonList_LoadsPokemons() {
        // Then
        let firstCard = app.buttons["\(AccessibilityIdentifiers.pokemonCard)1"]
        XCTAssertTrue(app.waitForElement(firstCard, timeout: 10))
    }
    
    func testPokemonList_ScrollsAndLoadsMore() {
        // Given
        let lastInitialPokemon = app.buttons["\(AccessibilityIdentifiers.pokemonCard)15"]
        
        // When
        app.swipeUp()
        app.swipeUp()
        app.swipeUp()
        
        // Then
        XCTAssertTrue(lastInitialPokemon.exists)
    }
    
    func testPokemonList_TapPokemon_NavigatesToDetail() {
        // When
        app.tapPokemonCard(id: 1)
        
        // Then
        let backButton = app.buttons[AccessibilityIdentifiers.backButton]
        XCTAssertTrue(app.waitForElement(backButton))
    }
}
