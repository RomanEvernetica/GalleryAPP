//
//  APIService.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import Alamofire
import Foundation

typealias APIResponse<T: Decodable> = (object: T?, error: Error?)

enum APIError: Error, LocalizedError {
    case invalidURL
    case decoding(Error)
    case server(Int, Data?)
    case underlying(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .decoding(let error):
            return "Decoding failed: \(error.localizedDescription)"
        case .server(let status, _):
            return "Server error: \(status)"
        case .underlying(let error):
            return "Unexpected error: \(error.localizedDescription)"
        case .unknown:
            return "Unknown error occurred"
        }
    }
}

class APIService {
    @MainActor
    func makeRequest<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let request = request(endpoint)
            .validate(statusCode: 200..<300)
            .serializingDecodable(T.self)

        do {
            return try await request.value
        } catch let afError as AFError {
            switch afError {
            case .responseValidationFailed(reason: let reason):
                if case .unacceptableStatusCode(let code) = reason {
                    let data = await request.response.data
                    throw APIError.server(code, data)
                } else {
                    throw APIError.underlying(afError)
                }

            case .responseSerializationFailed(reason: let reason):
                if case .decodingFailed(let decodingError) = reason {
                    throw APIError.decoding(decodingError)
                } else {
                    throw APIError.underlying(afError)
                }

            default:
                throw APIError.underlying(afError)
            }
        } catch {
            throw APIError.unknown
        }
    }

    private func request(_ endpoint: Endpoint) -> DataRequest {
        return AF.request(endpoint.url,
                          method: endpoint.method,
                          parameters: endpoint.params,
                          headers: endpoint.headers)
    }
}
