//
//  GalleryScreenView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 08.04.2025.
//

import SwiftUI

struct GalleryScreenView: View {
    @ObservedObject private var viewModel: GalleryViewModel

    init(viewModel: GalleryViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            GalleryView(viewModel: viewModel)
                .searchable(text: $viewModel.searchText, prompt: "Search photos")
                .navigationTitle("Photo Gallery")
        }
    }
}

#Preview {
    GalleryScreenView(viewModel: GalleryViewModel(flow: .main))
}
