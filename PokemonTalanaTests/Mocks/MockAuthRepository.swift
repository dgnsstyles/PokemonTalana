//
//  MockAuthRepository.swift
//  PokemonTalanaTests
//
//  Created by David Goren on 30-01-26.
//

import Foundation
@testable import PokemonTalana

class MockAuthRepository: AuthRepository {
    var savedUser: User?
    var isLoggedInValue = false
    var shouldFailValidation = false
    
    func saveUser(username: String, password: String) -> Bool {
        savedUser = User(username: username, createdAt: Date())
        isLoggedInValue = true
        return true
    }
    
    func getUser() -> User? {
        return savedUser
    }
    
    func validateUser(username: String, password: String) -> Bool {
        if shouldFailValidation {
            return false
        }
        return savedUser?.username == username
    }
    
    func isUserLoggedIn() -> Bool {
        return isLoggedInValue
    }
    
    func logout() {
        savedUser = nil
        isLoggedInValue = false
    }
}
