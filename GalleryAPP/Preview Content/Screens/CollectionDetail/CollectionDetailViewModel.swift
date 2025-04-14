//
//  CollectionDetailViewModel.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 11.04.2025.
//

import Foundation

@MainActor
class CollectionDetailViewModel: ObservableObject, Equatable {
    nonisolated static func == (lhs: CollectionDetailViewModel, rhs: CollectionDetailViewModel) -> Bool {
        return lhs.collection.id == rhs.collection.id
    }

    let collection: UnsplashCollection

    let galleryViewModel: GalleryViewModel

    init(collection: UnsplashCollection) {
        self.collection = collection
        self.galleryViewModel = GalleryViewModel(flow: .collection(collectionID: collection.id))
    }
}
