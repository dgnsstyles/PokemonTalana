//
//  usercaseofuse.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//

import Foundation

class AuthenticateUserUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func login(username: String, password: String) -> Bool {
        return repository.validateUser(username: username, password: password)
    }
    
    func register(username: String, password: String) -> Bool {
        return repository.saveUser(username: username, password: password)
    }
    
    func isLoggedIn() -> Bool {
        return repository.isUserLoggedIn()
    }
    
    func logout() {
        repository.logout()
    }
}
