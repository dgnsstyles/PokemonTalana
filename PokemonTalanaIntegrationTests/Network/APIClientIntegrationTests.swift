//
//  APIClientIntegrationTests.swift
//  PokemonTalanaIntegrationTests
//
//  Created by David Goren on 30-01-26.
//

import XCTest
import Combine
@testable import PokemonTalana

final class APIClientIntegrationTests: XCTestCase {
    private var sut: APIClient!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = APIClient.shared
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testAPIClient_FetchPokemonList_ReturnsValidData() {
        // Given
        let endpoint = Endpoints.pokemonList(offset: 0, limit: 20)
        let expectation = XCTestExpectation(description: "Fetch pokemon list from PokeAPI")
        var receivedResponse: PokemonListResponse?
        
        // When
        sut.request(endpoint: endpoint)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Request failed with error: \(error)")
                }
            }, receiveValue: { (response: PokemonListResponse) in
                receivedResponse = response
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 10.0)
        XCTAssertNotNil(receivedResponse)
        XCTAssertEqual(receivedResponse?.results.count, 20)
    }
    
    func testAPIClient_FetchPokemonDetail_ReturnsValidData() {
        // Given
        let endpoint = Endpoints.pokemonDetail(id: 1)
        let expectation = XCTestExpectation(description: "Fetch pokemon detail from PokeAPI")
        var receivedResponse: PokemonDetailResponse?
        
        // When
        sut.request(endpoint: endpoint)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Request failed with error: \(error)")
                }
            }, receiveValue: { (response: PokemonDetailResponse) in
                receivedResponse = response
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 10.0)
        XCTAssertNotNil(receivedResponse)
        XCTAssertEqual(receivedResponse?.id, 1)
        XCTAssertEqual(receivedResponse?.name, "bulbasaur")
    }
    
    func testAPIClient_InvalidEndpoint_ReturnsError() {
        // Given
        let endpoint = "https://pokeapi.co/api/v2/invalid_endpoint"
        let expectation = XCTestExpectation(description: "Fetch invalid endpoint returns error")
        var receivedError: Error?
        
        // When
        sut.request(endpoint: endpoint)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                    expectation.fulfill()
                }
            }, receiveValue: { (_: PokemonListResponse) in
                XCTFail("Should not receive value for invalid endpoint")
            })
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 10.0)
        XCTAssertNotNil(receivedError)
    }
}
