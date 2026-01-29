//
//  AuthRepository.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//

import Foundation

protocol AuthRepository {
    func saveUser(username: String, password: String) -> Bool
    func getUser() -> User?
    func validateUser(username: String, password: String) -> Bool
    func isUserLoggedIn() -> Bool
    func logout()
}
