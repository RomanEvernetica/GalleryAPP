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

    var errorBlock: Block<String>?
    var loaderBlock: Block<Bool>?

    init(apiService: UnsplashAPIService) {
        self.apiService = apiService
        self.observe()
    }

    func clean() {
        page = 1
        query = ""
    }

    func getNewItems(completion: Block<[UnsplashPhoto]>?) {
        clean()

        getItems(completion: completion)
    }

    private func getItems(completion: Block<[UnsplashPhoto]>?) {
        apiService.getItems(page: page) { items in
            completion?(items)
        }
    }

    func getMoreitems(completion: Block<[UnsplashPhoto]>?) {
        page += 1

        if !query.isEmpty {
            if canGetMore {
                searchItems(query: query, completion: completion)
            }
        } else {
            getItems(completion: completion)
        }
    }

    func getPhotoBy(id: String, completion: Block<UnsplashPhoto>?) {
        apiService.getPhotoBy(id: id, completion: completion)
    }

    func search(query: String, completion: Block<[UnsplashPhoto]>?) {
        if self.query == query { return }

        self.query = query
        page = 1

        searchItems(query: query, completion: completion)
    }

    private func searchItems(query: String, completion: Block<[UnsplashPhoto]>?) {
        apiService.searchItems(query: query, page: page) { [weak self] response in
            self?.total = response.total
            self?.totalPages = response.totalPages
            completion?(response.results)
        }
    }

    func processReponse(currentDS: [UnsplashPhoto], newItems: [UnsplashPhoto]) -> [UnsplashPhoto] {
            if self.page == 1 {
                return newItems
            } else {
                return currentDS + newItems
            }
    }

    private func observe() {
        apiService.errorBlock = { [weak self] error in
            self?.errorBlock?(error)
        }
        apiService.loaderBlock = { [weak self] isLoading in
            self?.loaderBlock?(isLoading)
        }
    }
}
