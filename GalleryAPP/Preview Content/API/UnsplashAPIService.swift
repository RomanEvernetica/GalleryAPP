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

    var errorBlock: Block<String>?
    var loaderBlock: Block<Bool>?

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func getItems(page: Int, completion: Block<[UnsplashPhoto]>?) {
        let endpoint: UnsplashEndpoint = .getPhotos(page: page)

        Task {
            loaderBlock?(true)
            defer { loaderBlock?(false) }

            let result = await apiService.makeRequest(endpoint, as: [UnsplashPhoto].self)
            switch result {
                case .success(let response):
                completion?(response)
            case .failure(let error):
                self.errorBlock?(error.localizedDescription)
            }
        }
    }

    func searchItems(query: String, page: Int, completion: Block<UnsplashSearchResults>?) {
        let endpoint: UnsplashEndpoint = .searchPhotos(query: query, page: page)

        Task {
            loaderBlock?(true)
            defer { loaderBlock?(false) }

            let result = await apiService.makeRequest(endpoint, as: UnsplashSearchResults.self)
            switch result {
                case .success(let response):
                completion?(response)
            case .failure(let error):
                self.errorBlock?(error.localizedDescription)
            }
        }
    }

    func getPhotoBy(id: String, completion: Block<UnsplashPhoto>?) {
        let endpoint: UnsplashEndpoint = .getPhoto(id: id)

        Task {
            loaderBlock?(true)
            defer { loaderBlock?(false) }

            let result = await apiService.makeRequest(endpoint, as: UnsplashPhoto.self)
            switch result {
                case .success(let response):
                completion?(response)
            case .failure(let error):
                self.errorBlock?(error.localizedDescription)
            }
        }
    }
}
