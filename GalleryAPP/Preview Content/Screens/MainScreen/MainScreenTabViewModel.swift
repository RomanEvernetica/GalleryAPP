//
//  MainScreenTabViewModel.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 12.04.2025.
//

import Foundation

@MainActor
class MainScreenTabViewModel {
    let galleryViewModel: GalleryViewModel
    let collectionsViewModel: CollectionsViewModel

    init() {
        self.galleryViewModel = GalleryViewModel()
        self.collectionsViewModel = CollectionsViewModel()
    }
}
