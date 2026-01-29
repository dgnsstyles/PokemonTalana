//
//  ApiClient.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//



import Foundation
import Combine

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
    case invalidResponse
}

class APIClient {
    static let shared = APIClient()
    private init() {}
    
    func request<T: Decodable>(endpoint: String) -> AnyPublisher<T, Error> {
        guard let url = URL(string: endpoint) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw APIError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return APIError.decodingFailed
                }
                return error
            }
            .eraseToAnyPublisher()
    }
}
