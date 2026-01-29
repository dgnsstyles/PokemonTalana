//
//  PokemonListViewModel.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//


import Foundation
import Combine

class PokemonListViewModel: ObservableObject {
    @Published var pokemons: [Pokemon] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let getPokemonListUseCase: GetPokemonListUseCase
    private var cancellables = Set<AnyCancellable>()
    private var currentOffset = 0
    private let limit = 20
    
    init(getPokemonListUseCase: GetPokemonListUseCase) {
        self.getPokemonListUseCase = getPokemonListUseCase
        loadPokemons()
    }
    
    func loadPokemons() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        getPokemonListUseCase.execute(offset: currentOffset, limit: limit)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] newPokemons in
                self?.pokemons.append(contentsOf: newPokemons)
                self?.currentOffset += self?.limit ?? 20
            }
            .store(in: &cancellables)
    }
    
    func loadMoreIfNeeded(currentPokemon: Pokemon) {
        guard let index = pokemons.firstIndex(where: { $0.id == currentPokemon.id }) else {
            return
        }
        
        if index == pokemons.count - 5 {
            loadPokemons()
        }
    }
}
