//
//  LoginViewModelTests.swift
//  PokemonTalanaTests
//
//  Created by David Goren on 30-01-26.
//

import XCTest
import Combine
@testable import PokemonTalana

final class LoginViewModelTests: XCTestCase {
    private var sut: LoginViewModel!
    private var mockUseCase: AuthenticateUserUseCase!
    private var mockRepository: MockAuthRepository!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockAuthRepository()
        mockUseCase = AuthenticateUserUseCase(repository: mockRepository)
        sut = LoginViewModel(authenticateUserUseCase: mockUseCase)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testLogin_WhenValidCredentials_SetsIsLoggedInTrue() {
        // Given
        mockRepository.saveUser(username: "test", password: "password")
        sut.username = "test"
        sut.password = "password"
        
        // When
        sut.login()
        
        // Then
        XCTAssertTrue(sut.isLoggedIn)
        XCTAssertNil(sut.errorMessage)
    }
    
    func testLogin_WhenInvalidCredentials_SetsErrorMessage() {
        // Given
        sut.username = "test"
        sut.password = "wrong"
        mockRepository.shouldFailValidation = true
        
        // When
        sut.login()
        
        // Then
        XCTAssertFalse(sut.isLoggedIn)
        XCTAssertEqual(sut.errorMessage, "Invalid credentials")
    }
    
    func testLogin_WhenEmptyFields_SetsErrorMessage() {
        // Given
        sut.username = ""
        sut.password = ""
        
        // When
        sut.login()
        
        // Then
        XCTAssertFalse(sut.isLoggedIn)
        XCTAssertEqual(sut.errorMessage, "Please enter username and password")
    }
    
    func testRegister_WhenValidCredentials_SetsIsLoggedInTrue() {
        // Given
        sut.username = "newuser"
        sut.password = "password"
        
        // When
        sut.register()
        
        // Then
        XCTAssertTrue(sut.isLoggedIn)
        XCTAssertNil(sut.errorMessage)
    }
    
    func testRegister_WhenEmptyFields_SetsErrorMessage() {
        // Given
        sut.username = ""
        sut.password = ""
        
        // When
        sut.register()
        
        // Then
        XCTAssertFalse(sut.isLoggedIn)
        XCTAssertEqual(sut.errorMessage, "Please enter username and password")
    }
}
