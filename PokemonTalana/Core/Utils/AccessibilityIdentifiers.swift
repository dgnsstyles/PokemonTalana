//
//  AccesibilityIdentifiers.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//

import Foundation

enum AccessibilityIdentifiers {
    // Login Screen
    static let loginUsernameField = "login_username_field"
    static let loginPasswordField = "login_password_field"
    static let loginButton = "login_button"
    static let registerButton = "register_button"
    static let biometricButton = "biometric_button"
    static let errorMessage = "error_message"
    
    // Pokemon List Screen
    static let pokemonList = "pokemon_list"
    static let pokemonCard = "pokemon_card_"
    static let searchField = "search_field"
    static let pokemonListTitle = "pokemon_list_title"
    
    // Pokemon Detail Screen
    static let pokemonDetailImage = "pokemon_detail_image"
    static let pokemonDetailName = "pokemon_detail_name"
    static let pokemonDetailID = "pokemon_detail_id"
    static let backButton = "back_button"
    static let favoriteStarButton = "favorite_star_button"
    
    // Favorites Screen
    static let favoritesButton = "favorites_button"
    static let favoritesList = "favorites_list"
    static let favoriteCard = "favorite_card_"
    static let removeFavoriteButton = "remove_favorite_button"
}
