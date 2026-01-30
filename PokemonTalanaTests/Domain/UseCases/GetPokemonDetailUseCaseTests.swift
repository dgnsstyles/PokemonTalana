//
//  GetPokemonDetailUseCaseTests.swift
//  PokemonTalanaTests
//
//  Created by David Goren on 30-01-26.
//

import XCTest
import Combine
@testable import PokemonTalana

final class GetPokemonDetailUseCaseTests: XCTestCase {
    private var sut: GetPokemonDetailUseCase!
    private var mockRepository: MockPokemonRepository!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockPokemonRepository()
        sut = GetPokemonDetailUseCase(repository: mockRepository)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testExecute_WhenSuccess_ReturnsPokemonDetail() {
        // Given
        let expectedDetail = MockData.pokemonDetail
        let expectation = XCTestExpectation(description: "Returns pokemon detail")
        var receivedDetail: PokemonDetail?
        
        // When
        sut.execute(id: 1)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { detail in
                receivedDetail = detail
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedDetail?.id, expectedDetail.id)
        XCTAssertEqual(receivedDetail?.name, expectedDetail.name)
    }
    
    func testExecute_WhenFailure_ReturnsError() {
        // Given
        mockRepository.shouldFail = true
        let expectation = XCTestExpectation(description: "Returns error")
        var receivedError: Error?
        
        // When
        sut.execute(id: 1)
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
