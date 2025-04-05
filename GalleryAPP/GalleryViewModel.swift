//
//  GalleryViewModel.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import Foundation

class GalleryViewModel: ObservableObject {
    private let paginaionService: UnsplashPaginationService

    @Published var photos: [UnsplashPhoto] = []
    @Published var isLoading = false
    @Published var searchText: String = "" {
        didSet {
//            if searchText != oldValue {
                getItems()
//            }
        }
    }

    init() {
        let apiService = APIService()
        let unsplashService = UnsplashAPIService(apiService: apiService)
        self.paginaionService = UnsplashPaginationService(apiService: unsplashService)
    }

    func didLoad() {
        observePagination()
        getItems()
    }

    func loadMoreIfNeeded(currentID: String) {
        guard let item = photos.last, item.id == currentID, !isLoading else { return }
        paginaionService.getMoreitems()
    }

    private func getItems() {
        paginaionService.getPhotos(searchText: searchText)
    }

    private func observePagination() {
        paginaionService.errorBlock = { [weak self] error in

        }
        paginaionService.loaderBlock = { [weak self] show in
            DispatchQueue.main.async {
                self?.isLoading = show
            }
        }
        paginaionService.reloadUIBlock = { [weak self] items in
            self?.photos = items
        }
    }
}
