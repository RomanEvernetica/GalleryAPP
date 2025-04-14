//
//  GalleryViewModel.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import Foundation

enum PhotoGalleryFlow {
    case main
    case collection(collectionID: String)
    case user(username: String)
}

@MainActor
class GalleryViewModel: ObservableObject {
    private let paginaionService: PaginationService<UnsplashPhoto>

    private var dataLoaded = false
    private let flow: PhotoGalleryFlow
    private var collectionID: String? {
        switch flow {
        case let .collection(collectionID):
            return collectionID
        default:
            return nil
        }
    }

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

    init(flow: PhotoGalleryFlow) {
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
        switch flow {
        case .main:
            return UnsplashEndpoint.getPhotos(page: page)
        case let .collection(collectionID):
            return UnsplashEndpoint.getCollectionPhotos(id: collectionID, page: page)
        case let .user(username):
            return UnsplashEndpoint.getUserPhotos(username: username, page: page)
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
