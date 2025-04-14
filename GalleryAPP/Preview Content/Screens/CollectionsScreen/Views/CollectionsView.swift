//
//  CollectionsView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 14.04.2025.
//

import SwiftUI

struct CollectionsView: View {
    private let spacing: CGFloat = 8
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    @ObservedObject private var viewModel: CollectionsViewModel
    @EnvironmentObject var router: MainRouter

    init(viewModel: CollectionsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            let totalSpacing: CGFloat = spacing * CGFloat(columns.count + 1)
            let itemWidth = (geometry.size.width - totalSpacing) / CGFloat(columns.count)

            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.dataSource) { item in
                        CollectionItemView(viewModel: item)
                            .scaledToFill()
                            .frame(width: itemWidth, height: itemWidth)
                            .clipped()
                            .cornerRadius(10)
                            .onAppear {
                                viewModel.loadMoreIfNeeded(currentID: item.id)
                            }
                            .onTapGesture {
                                let vm = CollectionDetailViewModel(collection: item.model)
                                router.navigateTo(route: .collection(vm: vm))
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
    CollectionsView(viewModel: CollectionsViewModel(flow: .main))
}
