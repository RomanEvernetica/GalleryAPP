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
    private let collectionID: String?
    private var dataLoaded = false

    @Published var dataSource: [GalleryItemViewModel] = []
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
    var showEmptyMessage: Bool {
        dataLoaded && dataSource.isEmpty
    }

    init(collectionID: String? = nil) {
        let apiService = APIService()
        self.paginaionService = PaginationService(apiService: apiService)
        self.collectionID = collectionID
        self.start()
    }

    private func start() {
        paginaionService.delegate = self
        getItems()
    }

    func loadMoreIfNeeded(currentID: String) {
        guard let item = dataSource.last, item.id == currentID, !isLoading, paginaionService.canGetMore else { return }

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
        let newVMs = newItems.map(makeVM)
        dataSource = paginaionService.processReponse(currentDS: dataSource, newItems: newVMs)
        dataLoaded = true
    }

    private func makeVM(photo: UnsplashPhoto) -> GalleryItemViewModel {
        return GalleryItemViewModel(item: photo)
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
        if let collectionID = collectionID {
            UnsplashEndpoint.getCollectionPhotos(id: collectionID, page: page)
        } else {
            UnsplashEndpoint.getPhotos(page: page)
        }
    }
    
    func searchEndpoint(query: String, page: Int) -> any Endpoint {
        var collections = [String]()
        if let collectionID = collectionID {
            collections.append(collectionID)
        }
        return UnsplashEndpoint.searchPhotos(query: query, page: page, collections: collections)
    }
}
