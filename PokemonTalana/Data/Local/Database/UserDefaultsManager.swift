//
//  UserDefaultsManager.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//


import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() {}
    
    private let userKey = "saved_user"
    private let isLoggedInKey = "is_logged_in"
    
    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
            UserDefaults.standard.set(true, forKey: isLoggedInKey)
        }
    }
    
    func getUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: userKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: isLoggedInKey)
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: userKey)
        UserDefaults.standard.set(false, forKey: isLoggedInKey)
    }
}
