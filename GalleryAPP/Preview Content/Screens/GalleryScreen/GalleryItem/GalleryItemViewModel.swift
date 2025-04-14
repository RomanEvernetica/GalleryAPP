//
//  GalleryItemViewModel.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 13.04.2025.
//

import Foundation

class GalleryItemViewModel: Identifiable, Equatable {
    static func == (lhs: GalleryItemViewModel, rhs: GalleryItemViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    let id: String
    let itemURL: URL?
    let fullImageURL: URL?

    init(item: UnsplashPhoto) {
        self.id = item.id
        self.itemURL = item.urls.small
        self.fullImageURL = item.urls.full
    }
}
