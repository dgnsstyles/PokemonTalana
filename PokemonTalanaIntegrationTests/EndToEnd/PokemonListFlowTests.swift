//
//  PokemonListFlowTests.swift
//  PokemonTalanaIntegrationTests
//
//  Created by David Goren on 30-01-26.
//

import XCTest
import Combine
@testable import PokemonTalana

final class PokemonListFlowTests: XCTestCase {
    private var sut: PokemonRepositoryImpl!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = PokemonRepositoryImpl()
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testCompletePokemonListFlow() {
        // Given
        let listExpectation = XCTestExpectation(description: "Fetch list")
        var firstPokemon: Pokemon?
        
        // When - Get List
        sut.getPokemonList(offset: 0, limit: 1)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { pokemons in
                firstPokemon = pokemons.first
                listExpectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [listExpectation], timeout: 10.0)
        
        // Then - Fetch Detail of that pokemon
        guard let pokemon = firstPokemon else {
            XCTFail("No pokemon found")
            return
        }
        
        let detailExpectation = XCTestExpectation(description: "Fetch detail")
        var pokemonDetail: PokemonDetail?
        
        sut.getPokemonDetail(id: pokemon.id)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { detail in
                pokemonDetail = detail
                detailExpectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [detailExpectation], timeout: 10.0)
        XCTAssertEqual(pokemonDetail?.id, pokemon.id)
    }
    
    func testPaginationFlow() {
        // Given
        let pagesCount = 3
        let limit = 20
        var allPokemons: [Pokemon] = []
        let expectation = XCTestExpectation(description: "Fetch 3 pages")
        
        // When
        Publishers.Sequence(sequence: 0..<pagesCount)
            .flatMap { page in
                self.sut.getPokemonList(offset: page * limit, limit: limit)
            }
            .collect()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { results in
                allPokemons = results.flatMap { $0 }
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 20.0)
        XCTAssertEqual(allPokemons.count, pagesCount * limit)
        
        let ids = allPokemons.map { $0.id }
        let uniqueIds = Set(ids)
        XCTAssertEqual(ids.count, uniqueIds.count, "Should not have duplicates")
        
        // Verify sequential IDs (assuming PokeAPI default ordering is by ID)
        for i in 0..<allPokemons.count {
            XCTAssertEqual(allPokemons[i].id, i + 1)
        }
    }
}
