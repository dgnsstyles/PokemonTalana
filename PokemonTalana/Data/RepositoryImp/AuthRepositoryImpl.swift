//
//  AuthRepositoryImpl.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//


import Foundation

class AuthRepositoryImpl: AuthRepository {
    private let userDefaultsManager: UserDefaultsManager
    private let keychainManager: KeychainManager
    
    init(userDefaultsManager: UserDefaultsManager = .shared,
         keychainManager: KeychainManager = .shared) {
        self.userDefaultsManager = userDefaultsManager
        self.keychainManager = keychainManager
    }
    
    func saveUser(username: String, password: String) -> Bool {
        let user = User(username: username, createdAt: Date())
        userDefaultsManager.saveUser(user)
        return keychainManager.savePassword(password, for: username)
    }
    
    func getUser() -> User? {
        return userDefaultsManager.getUser()
    }
    
    func validateUser(username: String, password: String) -> Bool {
        guard let user = userDefaultsManager.getUser() else {
            return false
        }
        
        // Ensure the stored password matches the provided one
        if let storedPassword = keychainManager.getPassword(for: username) {
            return user.username == username && storedPassword == password
        }
        return false
    }
    
    func isUserLoggedIn() -> Bool {
        return userDefaultsManager.isLoggedIn()
    }
    
    func logout() {
        if let user = userDefaultsManager.getUser() {
            keychainManager.deletePassword(for: user.username)
        }
        userDefaultsManager.logout()
    }
}

