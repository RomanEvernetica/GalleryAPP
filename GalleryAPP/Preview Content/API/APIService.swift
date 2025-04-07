//
//  APIService.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import Foundation

class APIService {
    typealias APIResponseBlock<T: Decodable> = (_ object: T?, _ error: Error?) -> Void

    private let accessKey = "xKHzSiDBKxy4leBpc_khVaBQniLQ2S9IgfyJ-VzBR2Q"
    private let baseURL = "https://api.unsplash.com"
    private let session = URLSession(configuration: .default)

    private func prepareRequest(endpoint: UnsplashEndpoint) -> URLRequest? {
        let url = URL(string: "\(baseURL)\(endpoint.path)")
        guard let url else { return nil }
        print(url)

        var request = URLRequest(url: url)
        request.setValue("v1", forHTTPHeaderField: "Accept-Version")
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }

    func makeRequest<T: Decodable>(endpoint: UnsplashEndpoint, completion: APIResponseBlock<T>?) {
        guard let request = prepareRequest(endpoint: endpoint) else {
            print("URLRequest is nil")
            return
        }

        session.dataTask(with: request) {data, response, error in
            if let error {
                completion?(nil, error)
                return
            }

            guard let data else {
                print("Data is nil")
                completion?(nil, nil)
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            // Serialize object
            do {
                let obj = try decoder.decode(T.self, from: data)
                completion?(obj, nil)
            } catch {
                completion?(nil, error)
            }
        }.resume()
    }
}
