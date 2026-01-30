//
//  AuthenticationFlowTests.swift
//  PokemonTalanaIntegrationTests
//
//  Created by David Goren on 30-01-26.
//

import XCTest
@testable import PokemonTalana

final class AuthenticationFlowTests: XCTestCase {
    private var sut: AuthRepositoryImpl!
    private var userDefaultsManager: UserDefaultsManager!
    
    override func setUp() {
        super.setUp()
        userDefaultsManager = UserDefaultsManager.shared
        sut = AuthRepositoryImpl(userDefaultsManager: userDefaultsManager)
        
        // Clear state before test
        clearData()
    }
    
    override func tearDown() {
        // Clear state after test
        clearData()
        sut = nil
        userDefaultsManager = nil
        super.tearDown()
    }
    
    private func clearData() {
        userDefaultsManager.logout()
        // Also clear Keychain just in case
        if let user = userDefaultsManager.getUser() {
            KeychainManager.shared.deletePassword(for: user.username)
        }
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
    
    func testCompleteAuthenticationFlow() {
        // Given
        let username = "test_user_\(UUID().uuidString)"
        let password = "secure_password_123"
        
        // When - Register
        let registerResult = sut.saveUser(username: username, password: password)
        XCTAssertTrue(registerResult)
        
        // Then - Verify Login state
        XCTAssertTrue(sut.isUserLoggedIn())
        
        // When - Logout
        sut.logout()
        
        // Then - Verify Logout state
        XCTAssertFalse(sut.isUserLoggedIn())
        
        // When - Login again
        let loginResult = sut.validateUser(username: username, password: password)
        
        // Then - Verify Success
        XCTAssertTrue(loginResult)
    }
    
    func testAuthenticationPersistence() {
        // Given
        let username = "persistent_user"
        let password = "password"
        _ = sut.saveUser(username: username, password: password)
        
        // When - Simulate app restart by creating new repository instance
        let newRepo = AuthRepositoryImpl(userDefaultsManager: UserDefaultsManager.shared)
        
        // Then
        XCTAssertTrue(newRepo.isUserLoggedIn())
        XCTAssertEqual(newRepo.getUser()?.username, username)
    }
}
