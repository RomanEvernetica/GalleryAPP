//
//  UnsplashPaginationService.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import Foundation

class UnsplashPaginationService {
    private let apiService: UnsplashAPIService
    private var page: Int = 1
    private var query: String?

    var items: [UnsplashPhoto] = []

    var errorBlock: Block<String>?
    var loaderBlock: Block<Bool>?
    var reloadUIBlock: Block<[UnsplashPhoto]>?

    init(apiService: UnsplashAPIService) {
        self.apiService = apiService
        self.observe()
    }

    func clean() {
        items.removeAll()
        page = 1
        query = nil
    }

    func getPhotos(searchText: String) {
        if query == searchText { return }

        query = searchText
        page = 1
        items.removeAll()

        getPhotos()
    }

    private func getPhotos() {
        if let query, !query.isEmpty {
            searchItems(query: query)
        } else {
            getItems()
        }
    }

    private func getItems() {
        apiService.getItems(page: page) { [weak self] items in
            self?.processItems(items)
        }
    }

    func getMoreitems() {
        page += 1

        getPhotos()
    }

    func getPhotoBy(id: String, completion: Block<UnsplashPhoto>?) {
        apiService.getPhotoBy(id: id, completion: completion)
    }

    private func searchItems(query: String) {
        apiService.searchItems(query: query, page: page) { [weak self] items in
            self?.processItems(items)
        }
    }

    private func processItems(_ items: [UnsplashPhoto]) {
        DispatchQueue.main.async {
            if self.page == 1 {
                self.items = items
            } else {
                self.items.append(contentsOf: items)
            }

            self.reloadUIBlock?(self.items)
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
