//
//  GalleryViewModel.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import Foundation

@MainActor
class GalleryViewModel: ObservableObject {
    private let paginaionService: PaginationService<UnsplashPhoto>

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
            } else if !searchText.isEmpty {
                searchItems()
            }
        }
    }

    init() {
        let apiService = APIService()
        paginaionService = PaginationService(apiService: apiService)
        start()
    }

    private func start() {
        paginaionService.delegate = self
        getItems()
    }

    func loadMoreIfNeeded(currentID: String) {
        guard let item = photos.last, item.id == currentID, !isLoading, paginaionService.canGetMore else { return }

        Task {
            isLoading = true
            defer { isLoading = false }

            let result = await paginaionService.getMoreitems()
            handleResult(result)
        }
    }

    private func getItems() {
        Task {
            isLoading = true
            defer { isLoading = false }

            let result = await paginaionService.getNewItems()
            handleResult(result)
        }
    }

    private func searchItems() {
        Task {
            isLoading = true
            defer { isLoading = false }

            let result = await paginaionService.search(query: searchText)
            handleResult(result)
        }
    }

    private func processDS(newItems: [UnsplashPhoto]) {
        photos = paginaionService.processReponse(currentDS: photos, newItems: newItems)
    }

    private func handleResult(_ result: APIResult<[UnsplashPhoto]>) {
        switch result {
        case let .success(items):
            processDS(newItems: items)
        case let .failure(error):
            showError(error.localizedDescription)
        }
    }

    private func showError(_ error: String) {
        alertMessage = error
        showAlert = true
    }
}

extension GalleryViewModel: @preconcurrency PaginationDelegate {
    func endpoint(page: Int) -> any Endpoint {
        UnsplashEndpoint.getPhotos(page: page)
    }
    
    func searchEndpoint(query: String, page: Int) -> any Endpoint {
        UnsplashEndpoint.searchPhotos(query: query, page: page, collections: [])
    }
}
