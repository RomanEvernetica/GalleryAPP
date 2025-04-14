//
//  CollectionItemViewModel.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 13.04.2025.
//

import Foundation

class CollectionItemViewModel: Identifiable {
    let model: UnsplashCollection

    var id: String { model.id }
    var url: URL? { model.coverPhoto?.urls.small }
    var title: String? { model.title }

    init(collection: UnsplashCollection) {
        self.model = collection
    }
}
