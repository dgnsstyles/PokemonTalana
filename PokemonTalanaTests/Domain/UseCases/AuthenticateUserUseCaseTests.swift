//
//  AuthenticateUserUseCaseTests.swift
//  PokemonTalanaTests
//
//  Created by David Goren  on 30-01-26.
//

import XCTest
@testable import PokemonTalana

final class AuthenticateUserUseCaseTests: XCTestCase {
    private var sut: AuthenticateUserUseCase!
    private var mockRepository: MockAuthRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockAuthRepository()
        sut = AuthenticateUserUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testRegister_WhenValidCredentials_ReturnsTrue() {
        // When
        let result = sut.register(username: "test", password: "password")
        
        // Then
        XCTAssertTrue(result)
        XCTAssertNotNil(mockRepository.savedUser, "User should be saved after registration")
        XCTAssertEqual(mockRepository.savedUser?.username, "test")
    }
    
    func testLogin_WhenValidCredentials_ReturnsTrue() {
        // Given
        _ = sut.register(username: "test", password: "password")
        
        // When
        let result = sut.login(username: "test", password: "password")
        
        // Then
        XCTAssertTrue(result)
    }
    
    func testLogin_WhenInvalidCredentials_ReturnsFalse() {
        // Given
        _ = sut.register(username: "test", password: "password")
        mockRepository.shouldFailValidation = true
        
        // When
        let result = sut.login(username: "test", password: "wrong_password")
        
        // Then
        XCTAssertFalse(result)
    }
    
    func testIsLoggedIn_WhenUserRegistered_ReturnsTrue() {
        // Given
        _ = sut.register(username: "test", password: "password")
        
        // When
        let result = sut.isLoggedIn()
        
        // Then
        XCTAssertTrue(result)
    }
    
    func testLogout_ClearsUserSession() {
        // Given
        _ = sut.register(username: "test", password: "password")
        
        // When
        sut.logout()
        
        // Then
        XCTAssertFalse(sut.isLoggedIn())
        XCTAssertNil(mockRepository.getUser())
    }
}
