//
//  Endpoints.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//



import Foundation

enum Endpoints {
    static let baseURL = "https://pokeapi.co/api/v2"
    
    static func pokemonList(offset: Int, limit: Int) -> String {
        "\(baseURL)/pokemon?offset=\(offset)&limit=\(limit)"
    }
    
    static func pokemonDetail(id: Int) -> String {
        "\(baseURL)/pokemon/\(id)"
    }
    
    static func pokemonByName(name: String) -> String {
        "\(baseURL)/pokemon/\(name)"
    }
}
