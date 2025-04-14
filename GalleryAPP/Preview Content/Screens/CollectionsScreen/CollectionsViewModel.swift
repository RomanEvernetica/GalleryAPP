//
//  CollectionsViewModel.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 11.04.2025.
//

import Foundation

enum CollectionsGalleryFlow {
    case main
    case user(username: String)
}

@MainActor
class CollectionsViewModel: ObservableObject {
    private let paginaionService: PaginationService<UnsplashCollection>

    private let flow: CollectionsGalleryFlow
    private var dataLoaded = false

    @Published var dataSource: [CollectionItemViewModel] = []
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

    init(flow: CollectionsGalleryFlow) {
        let apiService = APIService()
        self.paginaionService = PaginationService(apiService: apiService)
        self.flow = flow
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

    private func processDS(newItems: [UnsplashCollection]) {
        let newVMs = newItems.map(makeVM)
        dataSource = paginaionService.processReponse(currentDS: dataSource, newItems: newVMs)
        dataLoaded = true
    }

    private func makeVM(item: UnsplashCollection) -> CollectionItemViewModel {
        return CollectionItemViewModel(collection: item)
    }

    private func handleResult(_ result: APIResult<[UnsplashCollection]>) {
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

extension CollectionsViewModel: @preconcurrency PaginationDelegate {
    func endpoint(page: Int) -> any Endpoint {
        switch flow {
        case .main:
            return UnsplashEndpoint.getCollections(page: page)
        case let .user(username):
            return UnsplashEndpoint.getUserCollections(username: username, page: page)
        }
    }

    func searchEndpoint(query: String, page: Int) -> any Endpoint {
        UnsplashEndpoint.searchCollections(query: query, page: page)
    }
}
