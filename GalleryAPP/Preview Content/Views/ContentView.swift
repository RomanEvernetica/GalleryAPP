//
//  ContentView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import SwiftUI

struct ContentView: View {
    private let spacing: CGFloat = 8
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @StateObject private var viewModel = GalleryViewModel()

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let totalSpacing: CGFloat = spacing * CGFloat(columns.count + 1)
                let itemWidth = (geometry.size.width - totalSpacing) / CGFloat(columns.count)

                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.photos) { item in
                            NavigationLink {
                                if let url = item.urls.full {
                                    FullScreenView(url: url)
                                }
                            } label: {
                                GalleryItemView(item: item)
                                    .scaledToFill()
                                    .frame(width: itemWidth, height: itemWidth)
                                    .clipped()
                                    .cornerRadius(10)
                                    .onAppear {
                                        viewModel.loadMoreIfNeeded(currentID: item.id)
                                    }
                            }
                        }
                    }
                    .padding(spacing)
                    .searchable(text: $viewModel.searchText, prompt: "Search")
                }
                .onAppear {
                    viewModel.didLoad()
                }
                .overlay {
                    if viewModel.isLoading {
                        ProgressView()
                            .foregroundStyle(.primary)
                    }
                }
                .alert("Error", isPresented: $viewModel.showAlert) {
                    Button("ОК", role: .cancel) {}
                } message: {
                    Text(viewModel.alertMessage ?? "Unknown error")
                }
                .navigationTitle("Unsplash Gallery")
            }
        }
    }
}

#Preview {
    ContentView()
}
