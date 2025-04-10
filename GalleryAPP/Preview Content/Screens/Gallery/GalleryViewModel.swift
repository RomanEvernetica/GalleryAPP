//
//  GalleryViewModel.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import Foundation

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
        paginaionService.delegate = self
    }

    func onAppear() {
        getItems()
    }

    func loadMoreIfNeeded(currentID: String) {
        guard let item = photos.last, item.id == currentID, !isLoading, paginaionService.canGetMore else { return }

        Task {
            await MainActor.run { isLoading = true }
            defer { Task { await MainActor.run { isLoading = false } } }

            let result = await paginaionService.getMoreitems()
            await handleResult(result)
        }
    }

    private func getItems() {
        Task {
            await MainActor.run { isLoading = true }
            defer { Task { await MainActor.run { isLoading = false } } }

            let result = await paginaionService.getNewItems()
            await handleResult(result)
        }
    }

    private func searchItems() {
        Task {
            await MainActor.run { isLoading = true }
            defer { Task { await MainActor.run { isLoading = false } } }

            let result = await paginaionService.search(query: searchText)
            await handleResult(result)
        }
    }

    @MainActor
    private func processDS(newItems: [UnsplashPhoto]) {
        photos = paginaionService.processReponse(currentDS: photos, newItems: newItems)
    }

    @MainActor
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

extension GalleryViewModel: PaginationDelegate {
    func endpoint(page: Int) -> any Endpoint {
        UnsplashEndpoint.getPhotos(page: page)
    }
    
    func searchEndpoint(query: String, page: Int) -> any Endpoint {
        UnsplashEndpoint.searchPhotos(query: query, page: page, collections: [])
    }
}
