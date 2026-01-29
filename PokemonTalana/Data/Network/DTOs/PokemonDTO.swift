//
//  PokemonDTO.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//

import Foundation

struct PokemonListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonResult]
}

struct PokemonResult: Codable {
    let name: String
    let url: String
    
    var id: Int {
        let components = url.split(separator: "/")
        return Int(components[components.count - 1]) ?? 0
    }
    
    func toDomain() -> Pokemon {
        return Pokemon(id: id, name: name, url: url)
    }
}

struct PokemonDetailResponse: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonTypeDTO]
    let stats: [PokemonStatDTO]
    let abilities: [PokemonAbilityDTO]
    
    func toDomain() -> PokemonDetail {
        return PokemonDetail(
            id: id,
            name: name,
            height: height,
            weight: weight,
            types: types.map { $0.toDomain() },
            stats: stats.map { $0.toDomain() },
            abilities: abilities.map { $0.toDomain() }
        )
    }
}

struct PokemonTypeDTO: Codable {
    let slot: Int
    let type: TypeInfoDTO
    
    func toDomain() -> PokemonType {
        return PokemonType(slot: slot, type: type.toDomain())
    }
}

struct TypeInfoDTO: Codable {
    let name: String
    let url: String
    
    func toDomain() -> TypeInfo {
        return TypeInfo(name: name, url: url)
    }
}

struct PokemonStatDTO: Codable {
    let baseStat: Int
    let effort: Int
    let stat: StatInfoDTO
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
    
    func toDomain() -> PokemonStat {
        return PokemonStat(baseStat: baseStat, effort: effort, stat: stat.toDomain())
    }
}

struct StatInfoDTO: Codable {
    let name: String
    let url: String
    
    func toDomain() -> StatInfo {
        return StatInfo(name: name, url: url)
    }
}

struct PokemonAbilityDTO: Codable {
    let isHidden: Bool
    let slot: Int
    let ability: AbilityInfoDTO
    
    enum CodingKeys: String, CodingKey {
        case isHidden = "is_hidden"
        case slot, ability
    }
    
    func toDomain() -> PokemonAbility {
        return PokemonAbility(isHidden: isHidden, slot: slot, ability: ability.toDomain())
    }
}

struct AbilityInfoDTO: Codable {
    let name: String
    let url: String
    
    func toDomain() -> AbilityInfo {
        return AbilityInfo(name: name, url: url)
    }
}


