//
//  PokemonListViewModelTests.swift
//  PokemonTalanaTests
//
//  Created by David Goren on 30-01-26.
//

import XCTest
import Combine
@testable import PokemonTalana

final class PokemonListViewModelTests: XCTestCase {
    private var sut: PokemonListViewModel!
    private var mockUseCase: GetPokemonListUseCase!
    private var mockRepository: MockPokemonRepository!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockPokemonRepository()
        mockUseCase = GetPokemonListUseCase(repository: mockRepository)
        sut = PokemonListViewModel(getPokemonListUseCase: mockUseCase)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testLoadPokemons_WhenSuccess_UpdatesPokemonsList() {
        // Given
        let expectedCount = MockData.pokemonList.count
        let expectation = XCTestExpectation(description: "Updates pokemons list")
        
        sut.$pokemons
            .receive(on: DispatchQueue.main)
            .dropFirst() // Drop initial empty value
            .sink { pokemons in
                if pokemons.count == expectedCount {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.loadPokemons()
        
        // Then
        wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(sut.pokemons.count, expectedCount)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
    }
    
   
    
    func testLoadMoreIfNeeded_WhenNearEnd_LoadsMore() {
        // Given
        sut.pokemons = Array(repeating: MockData.pokemon1, count: 20)
        let expectation = XCTestExpectation(description: "Loads more pokemons")
        
        sut.$pokemons
            .sink { pokemons in
                if pokemons.count > 20 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sut.loadMoreIfNeeded(currentPokemon: sut.pokemons[15]) // 20 - 5 = 15 is the trigger point
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertGreaterThan(sut.pokemons.count, 20)
    }
}

