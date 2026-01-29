//
//  GetPokemon.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.


import Foundation
import Combine

class GetPokemonDetailUseCase {
    private let repository: PokemonRepository
    
    init(repository: PokemonRepository) {
        self.repository = repository
    }
    
    func execute(id: Int) -> AnyPublisher<PokemonDetail, Error> {
        return repository.getPokemonDetail(id: id)
    }
}
