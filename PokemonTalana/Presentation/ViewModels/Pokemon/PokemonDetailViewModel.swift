//
//  PokemonDetailViewModel.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//

import Foundation
import Combine

class PokemonDetailViewModel: ObservableObject {
    @Published var pokemonDetail: PokemonDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    let pokemonId: Int
    private let getPokemonDetailUseCase: GetPokemonDetailUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(pokemonId: Int, getPokemonDetailUseCase: GetPokemonDetailUseCase) {
        self.pokemonId = pokemonId
        self.getPokemonDetailUseCase = getPokemonDetailUseCase
        loadPokemonDetail()
    }
    
    func loadPokemonDetail() {
        isLoading = true
        errorMessage = nil
        
        getPokemonDetailUseCase.execute(id: pokemonId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] detail in
                self?.pokemonDetail = detail
            }
            .store(in: &cancellables)
    }
}

