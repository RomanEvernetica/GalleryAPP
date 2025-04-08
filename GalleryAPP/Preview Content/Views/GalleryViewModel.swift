//
//  GalleryViewModel.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import SwiftUI

class GalleryViewModel: ObservableObject {
    private let paginaionService: UnsplashPaginationService

    @Published var photos: [UnsplashPhoto] = []
    @Published var isLoading = false
    @Published var searchText: String = "" {
        didSet {
            if searchText.isEmpty && searchText != oldValue {
                getPhotos()
            } else {
                searchPhotos()
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
        getPhotos()
    }

    func loadMoreIfNeeded(currentID: String) async {
        guard let item = photos.last, item.id == currentID, !isLoading else { return }
        do {
            let items = try await paginaionService.getMoreitems()
            processDS(newItems: items)
        } catch {
            print(error.localizedDescription)
        }
    }

    private func getPhotos() {
        Task {
            await getItems()
        }
    }

    private func searchPhotos() {
        Task {
            await searchItems()
        }
    }

    private func getItems() async {
        do {
            let items = try await paginaionService.getNewItems()
            processDS(newItems: items)
        } catch {
            print(error.localizedDescription)
        }
    }

    private func searchItems() async {
        do {
            let items = try await paginaionService.search(query: searchText)
            processDS(newItems: items)
        } catch {
            print(error.localizedDescription)
        }
    }

    private func processDS(newItems: [UnsplashPhoto]) {
        DispatchQueue.main.async {
            self.photos = self.paginaionService.processReponse(currentDS: self.photos, newItems: newItems)
        }
    }

    private func observePagination() {
//        paginaionService.errorBlock = { [weak self] error in
//
//        }
        paginaionService.loaderBlock = { [weak self] show in
            DispatchQueue.main.async {
                self?.isLoading = show
            }
        }
    }
}
