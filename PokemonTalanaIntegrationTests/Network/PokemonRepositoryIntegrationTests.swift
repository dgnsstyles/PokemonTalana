//
//  PokemonRepositoryIntegrationTests.swift
//  PokemonTalanaIntegrationTests
//
//  Created by David Goren on 30-01-26.
//

import XCTest
import Combine
@testable import PokemonTalana

final class PokemonRepositoryIntegrationTests: XCTestCase {
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
    
    func testGetPokemonList_WithRealAPI_ReturnsPokemons() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch pokemons from Repository")
        var receivedPokemons: [Pokemon] = []
        
        // When
        sut.getPokemonList(offset: 0, limit: 20)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { pokemons in
                receivedPokemons = pokemons
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 10.0)
        XCTAssertEqual(receivedPokemons.count, 20)
        XCTAssertEqual(receivedPokemons.first?.id, 1)
    }
    
    func testGetPokemonDetail_WithRealAPI_ReturnsPokemonDetail() {
        // Given
        let pikachuId = 25
        let expectation = XCTestExpectation(description: "Fetch Pikachu detail")
        var receivedDetail: PokemonDetail?
        
        // When
        sut.getPokemonDetail(id: pikachuId)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { detail in
                receivedDetail = detail
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 10.0)
        XCTAssertNotNil(receivedDetail)
        XCTAssertEqual(receivedDetail?.name, "pikachu")
        XCTAssertFalse(receivedDetail?.types.isEmpty ?? true)
        XCTAssertFalse(receivedDetail?.stats.isEmpty ?? true)
        XCTAssertFalse(receivedDetail?.abilities.isEmpty ?? true)
    }
    
    func testGetPokemonList_WithPagination_ReturnsCorrectOffset() {
        // Given
        let expectation1 = XCTestExpectation(description: "Fetch page 1")
        let expectation2 = XCTestExpectation(description: "Fetch page 2")
        
        var page1Pokemons: [Pokemon] = []
        var page2Pokemons: [Pokemon] = []
        
        // When
        sut.getPokemonList(offset: 0, limit: 10)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { pokemons in
                page1Pokemons = pokemons
                expectation1.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation1], timeout: 10.0)
        
        sut.getPokemonList(offset: 10, limit: 10)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { pokemons in
                page2Pokemons = pokemons
                expectation2.fulfill()
            })
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation2], timeout: 10.0)
        XCTAssertEqual(page1Pokemons.count, 10)
        XCTAssertEqual(page2Pokemons.count, 10)
        XCTAssertNotEqual(page1Pokemons.first?.id, page2Pokemons.first?.id)
    }
}
