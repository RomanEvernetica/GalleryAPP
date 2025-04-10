//
//  PaginationService.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import Foundation

protocol PaginationDelegate: AnyObject {
    func endpoint(page: Int) -> Endpoint
    func searchEndpoint(query: String, page: Int) -> Endpoint
}

class PaginationService<T: Codable> {
    struct SearchResults: Codable {
        let total: Int
        let totalPages: Int
        let results: [T]

        enum CodingKeys: String, CodingKey {
            case total, results
            case totalPages = "total_pages"
        }
    }

    private let apiService: APIService
    private var page = 1
    private var query = ""

    var canGetMore: Bool = true

    weak var delegate: PaginationDelegate?

    init(apiService: APIService) {
        self.apiService = apiService
    }

    private func clean() {
        page = 1
        query = ""
    }

    func getNewItems() async -> APIResult<[T]> {
        clean()

        return await getItems()
    }

    private func getItems() async -> APIResult<[T]> {
        guard let endpoint = delegate?.endpoint(page: page) else {
            print("❌ [PAGINATION ERROR] No endpoint")
            return .failure(APIError.unknown)
        }

        return await apiService.makeRequest(endpoint)
    }

    func getMoreitems() async -> APIResult<[T]> {
        if canGetMore {
            page += 1

            if !query.isEmpty {
                return await searchItems(query: query)
            } else {
                return await getItems()
            }
        } else {
            return .success([])
        }
    }

    func search(query: String) async -> APIResult<[T]> {
        self.query = query
        page = 1

        return await searchItems(query: query)
    }

    private func searchItems(query: String) async -> APIResult<[T]> {
        guard let endpoint = delegate?.searchEndpoint(query: query, page: page) else {
            print("❌ [PAGINATION ERROR] No endpoint")
            return .failure(APIError.unknown)
        }

        let result: APIResult<SearchResults> = await apiService.makeRequest(endpoint)
        switch result {
        case let .success(response):
            return .success(response.results)
        case let .failure(error):
            return .failure(error)
        }
    }

    func processReponse(currentDS: [UnsplashPhoto], newItems: [UnsplashPhoto]) -> [UnsplashPhoto] {
        if newItems.isEmpty {
            canGetMore = false
        }

        if self.page == 1 {
            return newItems
        } else {
            return currentDS + newItems
        }
    }
}
