//
//  CollectionsScreenView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 11.04.2025.
//

import SwiftUI

struct CollectionsScreenView: View {
    @ObservedObject private var viewModel: CollectionsViewModel

    init(viewModel: CollectionsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            CollectionsView(viewModel: viewModel)
                .searchable(text: $viewModel.searchText, prompt: "Search collections")
                .navigationTitle("Collections")
        }
    }
}

#Preview {
    CollectionsScreenView(viewModel: CollectionsViewModel(flow: .main))
}
