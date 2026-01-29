//
//  PokemonRepository.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//

import Foundation
import Combine

protocol PokemonRepository {
    func getPokemonList(offset: Int, limit: Int) -> AnyPublisher<[Pokemon], Error>
    func getPokemonDetail(id: Int) -> AnyPublisher<PokemonDetail, Error>
    func getPokemonByName(name: String) -> AnyPublisher<Pokemon, Error>
}
