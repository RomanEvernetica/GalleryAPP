//
//  UnsplashAPIService.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import Foundation

typealias EmptyBlock = () -> Void
typealias Block<T> = (T) -> Void

class UnsplashAPIService {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func getItems(page: Int) async throws -> [UnsplashPhoto] {
        let endpoint: UnsplashEndpoint = .getPhotos(page: page)
        return try await apiService.makeRequest(endpoint)
    }

    func searchItems(query: String, page: Int) async throws -> UnsplashSearchResults {
        let endpoint: UnsplashEndpoint = .searchPhotos(query: query, page: page)
        return try await apiService.makeRequest(endpoint)
    }

    func getPhotoBy(id: String) async throws -> UnsplashPhoto {
        let endpoint: UnsplashEndpoint = .getPhoto(id: id)
        return try await apiService.makeRequest(endpoint)
    }
}
