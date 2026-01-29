//
//  PokemonRepositoryImpl.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//


import Foundation
import Combine

class PokemonRepositoryImpl: PokemonRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func getPokemonList(offset: Int, limit: Int) -> AnyPublisher<[Pokemon], Error> {
        let endpoint = Endpoints.pokemonList(offset: offset, limit: limit)
        
        return apiClient.request(endpoint: endpoint)
            .map { (response: PokemonListResponse) in
                response.results.map { $0.toDomain() }
            }
            .eraseToAnyPublisher()
    }
    
    func getPokemonDetail(id: Int) -> AnyPublisher<PokemonDetail, Error> {
        let endpoint = Endpoints.pokemonDetail(id: id)
        
        return apiClient.request(endpoint: endpoint)
            .map { (response: PokemonDetailResponse) in
                response.toDomain()
            }
            .eraseToAnyPublisher()
    }
    
    func getPokemonByName(name: String) -> AnyPublisher<Pokemon, Error> {
        let endpoint = Endpoints.pokemonByName(name: name.lowercased())
        
        return apiClient.request(endpoint: endpoint)
            .map { (response: PokemonDetailResponse) in
                let pokemonURL = "\(Endpoints.baseURL)/pokemon/\(response.id)/"
                return Pokemon(id: response.id, name: response.name, url: pokemonURL)
            }
            .eraseToAnyPublisher()
    }
}
