//
//  CompleteUserFlowTests.swift
//  PokemonTalanaUITests
//
//  Created by David Goren on 30-01-26.
//

import XCTest

final class CompleteUserFlowTests: XCTestCase {
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
    
    func testCompleteUserFlow_RegisterToViewPokemonDetail() {
        // PASO 1: Register
        let uniqueUsername = "flow_\(UUID().uuidString.prefix(8))"
        app.register(username: uniqueUsername, password: "password")
        
        // PASO 2 & 3: Verificar en lista & Wait for load
        let listTitle = app.staticTexts[AccessibilityIdentifiers.pokemonListTitle]
        XCTAssertTrue(app.waitForElement(listTitle))
        
        // PASO 4: Tap primer pokemon
        app.tapPokemonCard(id: 1)
        
        // PASO 5: Verificar detalle
        let detailName = app.staticTexts[AccessibilityIdentifiers.pokemonDetailName]
        XCTAssertTrue(app.waitForElement(detailName))
        XCTAssertEqual(detailName.label, "Bulbasaur")
        
        // PASO 6: Verificar secciones
        XCTAssertTrue(app.staticTexts["About"].exists)
        XCTAssertTrue(app.staticTexts["Base Stats"].exists)
        
        // PASO 7: Back button
        app.buttons[AccessibilityIdentifiers.backButton].tap()
        
        // PASO 8: Verificar en lista
        XCTAssertTrue(listTitle.exists)
    }
    
    func testCompleteUserFlow_BrowseMultiplePokemons() {
        // Given
        app.register(username: "browser_\(UUID().uuidString.prefix(4))", password: "pass")
        
        // When - View pokemon 1
        app.tapPokemonCard(id: 1)
        XCTAssertTrue(app.staticTexts["Bulbasaur"].exists)
        
        // Back
        app.buttons[AccessibilityIdentifiers.backButton].tap()
        
        // Scroll
        app.swipeUp()
        
        // View pokemon 5
        app.tapPokemonCard(id: 5)
        XCTAssertTrue(app.staticTexts["Charmeleon"].exists)
        
        // Back
        app.buttons[AccessibilityIdentifiers.backButton].tap()
        
        // Then - Back in list
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.pokemonListTitle].exists)
    }
    
    func testCompleteUserFlow_InvalidLoginThenRegister() {
        // When - Login fallido
        app.login(username: "nonexistent", password: "wrong")
        
        // Then - ver error
        let errorLabel = app.staticTexts[AccessibilityIdentifiers.errorMessage]
        XCTAssertTrue(app.waitForElement(errorLabel))
        
        // When - cambiar a register
        app.buttons.element(boundBy: 4).tap() // Toggle to register
        app.register(username: "new_from_flow_\(UUID().uuidString.prefix(4))", password: "password")
        
        // Then - éxito
        XCTAssertTrue(app.staticTexts[AccessibilityIdentifiers.pokemonListTitle].exists)
    }
}
