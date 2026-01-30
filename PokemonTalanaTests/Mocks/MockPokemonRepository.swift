//
//  MockPokemonRepository.swift
//  PokemonTalanaTests
//
//  Created by David Goren on on 30-01-26.
//

import Foundation
import Combine
@testable import PokemonTalana

class MockPokemonRepository: PokemonRepository {
    var shouldFail = false
    var pokemonListToReturn = MockData.pokemonList
    var pokemonDetailToReturn = MockData.pokemonDetail
    var pokemonByNameToReturn = MockData.pokemon1
    
    func getPokemonList(offset: Int, limit: Int) -> AnyPublisher<[Pokemon], Error> {
        if shouldFail {
            return Fail(error: NSError(domain: "Testing", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"]))
                .eraseToAnyPublisher()
        } else {
            return Just(pokemonListToReturn)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func getPokemonDetail(id: Int) -> AnyPublisher<PokemonDetail, Error> {
        if shouldFail {
            return Fail(error: NSError(domain: "Testing", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"]))
                .eraseToAnyPublisher()
        } else {
            return Just(pokemonDetailToReturn)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func getPokemonByName(name: String) -> AnyPublisher<Pokemon, Error> {
        if shouldFail {
            return Fail(error: NSError(domain: "Testing", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"]))
                .eraseToAnyPublisher()
        } else {
            return Just(pokemonByNameToReturn)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
