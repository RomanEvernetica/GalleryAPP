//
//  GalleryView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 14.04.2025.
//

import SwiftUI

struct GalleryView: View {
    private let spacing: CGFloat = 8
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    @ObservedObject private var viewModel: GalleryViewModel
    @EnvironmentObject var router: MainRouter

    init(viewModel: GalleryViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            let totalSpacing: CGFloat = spacing * CGFloat(columns.count + 1)
            let itemWidth = (geometry.size.width - totalSpacing) / CGFloat(columns.count)

            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.dataSource) { item in
                        GalleryItemView(viewModel: item)
                            .scaledToFill()
                            .frame(width: itemWidth, height: itemWidth)
                            .clipped()
                            .cornerRadius(10)
                            .onAppear {
                                viewModel.loadMoreIfNeeded(currentID: item.id)
                            }
                            .onTapGesture {
                                if item.fullImageURL != nil {
                                    router.navigateTo(route: .fullScreen(vm: item))
                                }
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

                if viewModel.showEmptyMessage {
                    Text("No results")
                }
            }
            .alert("Error", isPresented: $viewModel.showAlert) {
                Button("ОК", role: .cancel) {}
            } message: {
                Text(viewModel.alertMessage ?? "Unknown error")
            }
        }
    }
}

#Preview {
    GalleryView(viewModel: GalleryViewModel(flow: .main))
}
