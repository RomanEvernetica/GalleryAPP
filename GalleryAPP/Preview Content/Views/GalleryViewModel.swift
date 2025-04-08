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
    @Published var alertMessage: String? = nil
    @Published var showAlert: Bool = false {
        didSet {
            if showAlert == false {
                alertMessage = nil
            }
        }
    }
    @Published var searchText: String = "" {
        didSet {
            if searchText.isEmpty && searchText != oldValue {
                getItems()
            } else {
                searchItems()
            }
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
        paginaionService.getMoreitems() { [weak self] newItems in
            self?.processDS(newItems: newItems)
        }
    }

    private func getItems() {
        paginaionService.getNewItems() { [weak self] newItems in
            self?.processDS(newItems: newItems)
        }
    }

    private func searchItems() {
        paginaionService.search(query: searchText) { [weak self] newItems in
            self?.processDS(newItems: newItems)
        }
    }

    private func processDS(newItems: [UnsplashPhoto]) {
        DispatchQueue.main.async {
            self.photos = self.paginaionService.processReponse(currentDS: self.photos, newItems: newItems)
        }
    }

    private func observePagination() {
        paginaionService.errorBlock = { [weak self] error in
            self?.showError(error)
        }
        paginaionService.loaderBlock = { [weak self] show in
            DispatchQueue.main.async {
                self?.isLoading = show
            }
        }
    }

    private func showError(_ error: String) {
        alertMessage = error
        showAlert = true
    }
}
