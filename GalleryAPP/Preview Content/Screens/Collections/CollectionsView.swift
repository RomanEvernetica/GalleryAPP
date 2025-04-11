//
//  CollectionsView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 11.04.2025.
//

import SwiftUI

struct CollectionsView: View {
    private let spacing: CGFloat = 8
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    @StateObject private var viewModel = CollectionsViewModel()
    @EnvironmentObject var router: MainRouter

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let totalSpacing: CGFloat = spacing * CGFloat(columns.count + 1)
                let itemWidth = (geometry.size.width - totalSpacing) / CGFloat(columns.count)

                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.dataSource) { item in
                            CollectionItemView(item: item)
                                .scaledToFill()
                                .frame(width: itemWidth, height: itemWidth)
                                .clipped()
                                .cornerRadius(10)
                                .onAppear {
                                    viewModel.loadMoreIfNeeded(currentID: item.id)
                                }
                                .onTapGesture {
                                    router.navigateTo(route: .collection(item: item))
                                }
                        }
                    }
                    .padding(spacing)
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
                .searchable(text: $viewModel.searchText, prompt: "Search collections")
                .navigationTitle("Collections")
            }
        }
    }
}

#Preview {
    CollectionsView()
}
