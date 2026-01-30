//
//  MockData.swift
//  PokemonTalanaTests
//
//  Created by David Goren on 30-01-26.
//

import Foundation
@testable import PokemonTalana

struct MockData {
    static let pokemon1 = Pokemon(id: 1, name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")
    static let pokemon2 = Pokemon(id: 4, name: "charmander", url: "https://pokeapi.co/api/v2/pokemon/4/")
    static let pokemon3 = Pokemon(id: 7, name: "squirtle", url: "https://pokeapi.co/api/v2/pokemon/7/")
    
    static let pokemonList = [pokemon1, pokemon2, pokemon3]
    
    static let pokemonDetail = PokemonDetail(
        id: 1,
        name: "bulbasaur",
        height: 7,
        weight: 69,
        types: [
            PokemonType(slot: 1, type: TypeInfo(name: "grass", url: "https://pokeapi.co/api/v2/type/12/")),
            PokemonType(slot: 2, type: TypeInfo(name: "poison", url: "https://pokeapi.co/api/v2/type/4/"))
        ],
        stats: [
            PokemonStat(baseStat: 45, effort: 0, stat: StatInfo(name: "hp", url: "https://pokeapi.co/api/v2/stat/1/")),
            PokemonStat(baseStat: 49, effort: 0, stat: StatInfo(name: "attack", url: "https://pokeapi.co/api/v2/stat/2/"))
        ],
        abilities: [
            PokemonAbility(isHidden: false, slot: 1, ability: AbilityInfo(name: "overgrow", url: "https://pokeapi.co/api/v2/ability/65/")),
            PokemonAbility(isHidden: true, slot: 3, ability: AbilityInfo(name: "chlorophyll", url: "https://pokeapi.co/api/v2/ability/34/"))
        ]
    )
    
    static let user = User(username: "testuser", createdAt: Date())
}
