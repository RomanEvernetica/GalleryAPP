//
//  APIService.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import Alamofire
import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL(String)
    case decoding(Error)
    case server(Int)
    case underlying(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case let .invalidURL(url):
            return "Invalid URL \(url)"
        case let .decoding(error):
            return "Decoding failed: \(error.localizedDescription)"
        case let .server(status):
            return "Server error: \(status)"
        case let .underlying(error):
            return "Unexpected error: \(error.localizedDescription)"
        case .unknown:
            return "Unknown error occurred"
        }
    }
}

enum APIResult<T: Decodable> {
    case success(T)
    case failure(Error)
}

class APIService {
    @MainActor
    func makeRequest<T: Decodable>(_ endpoint: Endpoint) async -> APIResult<T> {
        let requestId = UUID().uuidString



        do {
            let dataTask = AF.request(endpoint.url,
                                      method: endpoint.method,
                                      parameters: endpoint.params,
                                      headers: endpoint.headers)
            HTTPLogger.logRequest(
                id: requestId,
                url: endpoint.url,
                method: endpoint.method.rawValue,
                headers: endpoint.headers.dictionary,
                body: dataTask.request?.httpBody
            )

            let response = await dataTask.serializingData().response

            HTTPLogger.logResponse(
                id: requestId,
                data: response.data,
                statusCode: response.response?.statusCode
            )

            let decoded = try JSONDecoder().decode(T.self, from: response.data!)
            return .success(decoded)

        } catch let afError as AFError {
            HTTPLogger.logError(id: requestId, afError)
            return .failure(errorHandler(afError))
        } catch {
            HTTPLogger.logError(id: requestId, error)
            return .failure(APIError.unknown)
        }
    }


    private func request(_ endpoint: Endpoint) -> DataRequest {
        return AF.request(endpoint.url,
                          method: endpoint.method,
                          parameters: endpoint.params,
                          headers: endpoint.headers)
    }

    private func errorHandler(_ error: AFError) -> APIError {
        switch error {
        case let .responseValidationFailed(reason):
            if case let .unacceptableStatusCode(code) = reason {
                return APIError.server(code)
            } else {
                return APIError.underlying(error)
            }

        case let .responseSerializationFailed(reason):
            if case let .decodingFailed(decodingError) = reason {
                return APIError.decoding(decodingError)
            } else {
                return APIError.underlying(error)
            }

        case let .invalidURL(url):
            return APIError.invalidURL(url as? String ?? "")

        default:
            return APIError.underlying(error)
        }
    }
}
