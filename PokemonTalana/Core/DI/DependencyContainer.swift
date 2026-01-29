//
//  DependencyContainer.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//

import Foundation

class DependencyContainer {
    static let shared = DependencyContainer()
    
    private init() {}
    
    // MARK: - Repositories
    private lazy var pokemonRepository: PokemonRepository = {
        PokemonRepositoryImpl()
    }()
    
    private lazy var authRepository: AuthRepository = {
        AuthRepositoryImpl()
    }()
    
    // MARK: - Use Cases
    private lazy var getPokemonListUseCase: GetPokemonListUseCase = {
        GetPokemonListUseCase(repository: pokemonRepository)
    }()
    
    private lazy var getPokemonDetailUseCase: GetPokemonDetailUseCase = {
        GetPokemonDetailUseCase(repository: pokemonRepository)
    }()
    
    private lazy var authenticateUserUseCase: AuthenticateUserUseCase = {
        AuthenticateUserUseCase(repository: authRepository)
    }()
    
    // MARK: - ViewModels
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(authenticateUserUseCase: authenticateUserUseCase)
    }
    
    func makePokemonListViewModel() -> PokemonListViewModel {
        PokemonListViewModel(getPokemonListUseCase: getPokemonListUseCase)
    }
    
    func makePokemonDetailViewModel(pokemonId: Int) -> PokemonDetailViewModel {
        PokemonDetailViewModel(pokemonId: pokemonId, getPokemonDetailUseCase: getPokemonDetailUseCase)
    }
}
