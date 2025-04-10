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

    func getPhotoBy(id: String, completion: Block<UnsplashPhoto>?) {
        let endpoint: UnsplashEndpoint = .getPhoto(id: id)

        Task {
            loaderBlock?(true)
            defer { loaderBlock?(false) }

            let result: APIResult<UnsplashPhoto> = await apiService.makeRequest(endpoint)
            switch result {
                case .success(let response):
                completion?(response)
            case .failure(let error):
                self.errorBlock?(error.localizedDescription)
            }
        }
    }
}
