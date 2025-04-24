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
    case requestError(Error, Int)
    case server(Int)
    case underlying(Error)
    case responseError(AFError)
    case networkConnection
    case unknown

    var errorDescription: String {
        switch self {
        case let .invalidURL(url):
            return "Invalid URL \(url)"
        case let .decoding(error):
            return "Decoding failed: \(error.localizedDescription)"
        case let .requestError(error, _):
            return "Response error: \(error.localizedDescription)"
        case let .server(status):
            return "Server error: \(status)"
        case let .underlying(error):
            return "Unexpected error: \(error.localizedDescription)"
        case .networkConnection:
            return "Network connection problem. Please try again."
        case let .responseError(error):
            return "Response error: \(error.localizedDescription)"
        case .unknown:
            return "Unknown error occurred"
        }
    }
}

enum APIResult<T: Decodable> {
    case success(T)
    case failure(APIError)
}

protocol APIServiceProtocol {
    func makeRequest<T: Decodable>(_ endpoint: Endpoint) async -> APIResult<T>
}

class APIService: APIServiceProtocol, ObservableObject {
    static let shared = APIService()

    private lazy var sessionInterceptor = APIInterceptor()

    private lazy var sessionManager: Session = {
        return Session(configuration: configuration(timeout: 30),
                       interceptor: sessionInterceptor)
    }()

    private func configuration(timeout: TimeInterval) -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeout
        configuration.timeoutIntervalForResource = timeout
        configuration.waitsForConnectivity = true
        return configuration
    }

    @MainActor
    func makeRequest<T: Decodable>(_ endpoint: Endpoint) async -> APIResult<T> {
        let request = request(endpoint)

        let dataTask = request.validate(statusCode: 200..<300).serializingDecodable(T.self)

        return await handleResponse(dataRequest: request, dataTask: dataTask)
    }


    private func request(_ endpoint: Endpoint) -> DataRequest {
        if let endpoint = endpoint as? URLRequestConvertible {
            return sessionManager.request(endpoint)
        } else {
            return sessionManager.request(endpoint.url,
                                          method: endpoint.method,
                                          parameters: endpoint.params,
                                          headers: endpoint.headers)
        }
    }

    private func handleResponse<T: Decodable>(dataRequest: DataRequest,
                                              dataTask: DataTask<T>) async -> APIResult<T> {
        let response = await dataTask.response

        // Debug
        printResponse(dataRequest: dataRequest, responseInfo: response)

        // Check error code nil, it means that internet may be offline
        if let error = response.error {
           if let underlyingError = error.underlyingError,
              let urlError = underlyingError as? URLError {
               switch urlError.code {
               case .notConnectedToInternet:
                   return .failure(printError(.networkConnection))
               default:
                   return .failure(errorHandler(error))
               }
           } else {
               return .failure(errorHandler(error))
           }
        }

        // Check data
        guard let responseData = response.data else {
            // Check response error
            if let error = response.error {
                return .failure(printError(.responseError(error)))
            } else {
                return .failure(printError(.unknown))
            }
        }

        // Check response error
//        if response.error != nil,
//           let responseObject = try? JSONSerialization.jsonObject(with: responseData) as? [String: Any],
//           let message = responseObject["message"] as? String {
//            sendError(message: message)
//            return
//        }

        // Serialize object
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.iso8601Full)

        do {
            let decoded = try decoder.decode(T.self, from: responseData)
            return .success(decoded)
        } catch {
            return .failure(printError(.decoding(error)))
        }
    }

    private func errorHandler(_ error: AFError) -> APIError {
        switch error {
        case let .responseValidationFailed(reason):
            if case let .unacceptableStatusCode(code) = reason {
                if code >= 500 {
                    return printError(.server(code))
                } else if code >= 400 {
                    return printError(.requestError(error, code))
                } else {
                    return printError(.underlying(error))
                }
            } else {
                return printError(.underlying(error))
            }

        case let .responseSerializationFailed(reason):
            switch reason {
            case let .jsonSerializationFailed(error),
                let .decodingFailed(error),
                let .customSerializationFailed(error):
                return printError(.decoding(error))
            default:
                return printError(.underlying(error))
            }

        case let .invalidURL(url):
            return printError(.invalidURL(url as? String ?? ""))

        default:
            return printError(.underlying(error))
        }
    }
}

extension APIService {
    private func printResponse<T: Decodable>(dataRequest: DataRequest, responseInfo: AFDataResponse<T>) {
        var bodyString = ""
        if let httpBody = dataRequest.request?.httpBody {
            bodyString = String(data: httpBody, encoding: String.Encoding.utf8) ?? ""
        }

        let unknownText = "nil"
        let urlString = dataRequest.request?.url?.absoluteString

        print("\n")
        print("⬆️ \(Date().string(.hhmmss)) REQUEST URL:", urlString ?? unknownText)
        print("REQUEST METHOD:", dataRequest.request?.method ?? unknownText)
        print("REQUEST HEADERS:\n", dataRequest.request?.headers.description ?? unknownText)
        print("REQUEST DATA:", bodyString)

        if let response = responseInfo.response {
            print(200..<300 ~= response.statusCode ? "✅" : "❌", "RESPONSE CODE", response.statusCode)

            if let data = responseInfo.data,
               let dataStr = String(data: data, encoding: .utf8) {
                let errorIndex = dataStr.count > 300 ? dataStr.index(dataStr.startIndex, offsetBy: 300) : dataStr.endIndex
                let index = 404...500 ~= response.statusCode ? errorIndex : dataStr.endIndex
                let error = dataStr[..<index]
                print("⬇️ \(Date().string(.hhmmss)) RESPONSE DATA:\n", error)
            }
        }
        print("\n")
    }

    private func printError(_ error: APIError) -> APIError {
        print("\n")
        print("❌ \(Date().string(.hhmmss)) [API ERROR]:", error.errorDescription)
        return error
    }
}

final class APIInterceptor: RequestInterceptor {
    private let retryLimit = 3

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Swift.Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if request.request?.method != .get {
            completion(.doNotRetry)
            return
        }
        if error.asAFError?.responseCode != nil {
            completion(.doNotRetry)
            return
        }
        guard request.retryCount < retryLimit else {
            completion(.doNotRetry)
            return
        }
        let retryTime = request.retryCount + 1
        completion(.retryWithDelay(TimeInterval(retryTime)))
    }
}
