//
//  GetPokemonList.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//

import Foundation
import Combine

class GetPokemonListUseCase {
    private let repository: PokemonRepository
    
    init(repository: PokemonRepository) {
        self.repository = repository
    }
    
    func execute(offset: Int, limit: Int = 20) -> AnyPublisher<[Pokemon], Error> {
        return repository.getPokemonList(offset: offset, limit: limit)
    }
}
