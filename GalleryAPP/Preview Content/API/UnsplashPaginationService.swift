//
//  UnsplashPaginationService.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import Foundation

class UnsplashPaginationService {
    private let apiService: UnsplashAPIService
    private var page = 1
    private var query = ""

    private var total = 0
    private var totalPages = 0
    private var canGetMore: Bool {
        totalPages > page
    }

    var loaderBlock: Block<Bool>?

    init(apiService: UnsplashAPIService) {
        self.apiService = apiService
    }

    func clean() {
        page = 1
        query = ""
    }

    func getNewItems() async throws -> [UnsplashPhoto] {
        clean()

        return try await getItems()
    }

    private func getItems() async throws -> [UnsplashPhoto] {
        loaderBlock?(true)
        defer { loaderBlock?(false) }

        return try await apiService.getItems(page: page)
    }

    func getMoreitems() async throws -> [UnsplashPhoto] {
        page += 1

        if !query.isEmpty && canGetMore {
            return try await searchItems(query: query)
        } else {
            return try await getItems()
        }
    }

    func getPhotoBy(id: String) async throws -> UnsplashPhoto {
        loaderBlock?(true)
        defer { loaderBlock?(false) }

        return try await apiService.getPhotoBy(id: id)
    }

    func search(query: String) async throws -> [UnsplashPhoto] {
        self.query = query
        page = 1

        return try await searchItems(query: query)
    }

    private func searchItems(query: String) async throws -> [UnsplashPhoto] {
        loaderBlock?(true)
        defer { loaderBlock?(false) }

        let response = try await apiService.searchItems(query: query, page: page)
        total = response.total
        totalPages = response.totalPages
        return response.results
    }

    func processReponse(currentDS: [UnsplashPhoto], newItems: [UnsplashPhoto]) -> [UnsplashPhoto] {
            if self.page == 1 {
                return newItems
            } else {
                return currentDS + newItems
            }
    }
}
