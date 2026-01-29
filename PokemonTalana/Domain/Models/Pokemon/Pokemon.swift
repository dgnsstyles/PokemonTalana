//
//  Pokemon.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//

import Foundation

struct Pokemon: Identifiable, Codable {
    let id: Int
    let name: String
    let url: String
    
    var imageURL: String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
    }
    
    var formattedID: String {
        String(format: "#%03d", id)
    }
}
