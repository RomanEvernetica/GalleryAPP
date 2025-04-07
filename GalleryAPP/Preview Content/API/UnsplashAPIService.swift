//
//  UnsplashAPIService.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import Foundation

typealias EmptyBlock = () -> Void
typealias Block<T> = (T) -> Void

enum UnsplashEndpoint {
    case getPhotos(page: Int)
    case searchPhotos(query: String, page: Int)
    case getPhoto(id: String)

    var path: String {
        switch self {
        case let .getPhotos(page):
            return "/photos?page=\(page)"
        case let .searchPhotos(query, page):
            return "/search/photos?page=\(page)&query=\(query)"
        case let .getPhoto(id):
            return "/photos/\(id)"
        }
    }
}

struct UnsplashSearchResults: Codable {
    let total: Int
    let totalPages: Int
    let results: [UnsplashPhoto]

    enum CodingKeys: String, CodingKey {
        case total, results
        case totalPages = "total_pages"
    }
}

class UnsplashAPIService {
    private let apiService: APIService

    var errorBlock: Block<String>?
    var loaderBlock: Block<Bool>?

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func getItems(page: Int, completion: Block<[UnsplashPhoto]>?) {
        let endpoint: UnsplashEndpoint = .getPhotos(page: page)
        loaderBlock?(true)
        apiService.makeRequest(endpoint: endpoint) { [weak self] (response: [UnsplashPhoto]?, error) in
            self?.loaderBlock?(false)
            if let error = error {
                self?.errorBlock?(error.localizedDescription)
                return
            }

            guard let response else {
                self?.errorBlock?("No data found.")
                return
            }

            completion?(response)
        }
    }

    func searchItems(query: String, page: Int, completion: Block<UnsplashSearchResults>?) {
        let endpoint: UnsplashEndpoint = .searchPhotos(query: query, page: page)
        loaderBlock?(true)
        apiService.makeRequest(endpoint: endpoint) { [weak self] (response: UnsplashSearchResults?, error) in
            self?.loaderBlock?(false)
            if let error = error {
                self?.errorBlock?(error.localizedDescription)
                return
            }

            guard let response else {
                self?.errorBlock?("No data found.")
                return
            }

            completion?(response)
        }
    }

    func getPhotoBy(id: String, completion: Block<UnsplashPhoto>?) {
        let endpoint: UnsplashEndpoint = .getPhoto(id: id)
        loaderBlock?(true)
        apiService.makeRequest(endpoint: endpoint) { [weak self] (response: UnsplashPhoto?, error) in
            self?.loaderBlock?(false)
            if let error = error {
                self?.errorBlock?(error.localizedDescription)
                return
            }

            guard let response else {
                self?.errorBlock?("No data found.")
                return
            }

            completion?(response)
        }
    }
}
