//
//  GetPokemonListUseCaseTests.swift
//  PokemonTalanaTests
//
//  Created by David Goren on 30-01-26.
//

import XCTest
import Combine
@testable import PokemonTalana

final class GetPokemonListUseCaseTests: XCTestCase {
    private var sut: GetPokemonListUseCase!
    private var mockRepository: MockPokemonRepository!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockPokemonRepository()
        sut = GetPokemonListUseCase(repository: mockRepository)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testExecute_WhenSuccess_ReturnsPokemonList() {
        // Given
        let expectedPokemons = MockData.pokemonList
        let expectation = XCTestExpectation(description: "Returns pokemon list")
        var receivedPokemons: [Pokemon] = []
        
        // When
        sut.execute(offset: 0, limit: 20)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { pokemons in
                receivedPokemons = pokemons
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedPokemons.count, expectedPokemons.count)
        XCTAssertEqual(receivedPokemons.first?.name, expectedPokemons.first?.name)
    }
    
    func testExecute_WhenFailure_ReturnsError() {
        // Given
        mockRepository.shouldFail = true
        let expectation = XCTestExpectation(description: "Returns error")
        var receivedError: Error?
        
        // When
        sut.execute(offset: 0, limit: 20)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(receivedError)
    }
}
