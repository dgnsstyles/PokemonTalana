//
//  PokemonDetail.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//

import Foundation

struct PokemonDetail: Identifiable, Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonType]
    let stats: [PokemonStat]
    let abilities: [PokemonAbility]
    
    var imageURL: String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
    }
    
    var formattedID: String {
        String(format: "#%03d", id)
    }
    
    var heightInMeters: String {
        String(format: "%.1f m", Double(height) / 10)
    }
    
    var weightInKg: String {
        String(format: "%.1f kg", Double(weight) / 10)
    }
}

struct PokemonType: Codable, Identifiable {
    let id = UUID()
    let slot: Int
    let type: TypeInfo
    
    enum CodingKeys: String, CodingKey {
        case slot, type
    }
}

struct TypeInfo: Codable {
    let name: String
    let url: String
}

struct PokemonStat: Codable, Identifiable {
    let id = UUID()
    let baseStat: Int
    let effort: Int
    let stat: StatInfo
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
}

struct StatInfo: Codable {
    let name: String
    let url: String
}

struct PokemonAbility: Codable, Identifiable {
    let id = UUID()
    let isHidden: Bool
    let slot: Int
    let ability: AbilityInfo
    
    enum CodingKeys: String, CodingKey {
        case isHidden = "is_hidden"
        case slot, ability
    }
}

struct AbilityInfo: Codable {
    let name: String
    let url: String
}
