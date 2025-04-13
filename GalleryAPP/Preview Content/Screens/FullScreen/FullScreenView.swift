//
//  FullScreenView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 04.04.2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct FullScreenView: View {
    private let viewModel: FullScreenViewModel

    @State private var scale: CGFloat = 1.0
    @GestureState private var gestureScale: CGFloat = 1.0

    init(viewModel: FullScreenViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            WebImage(url: viewModel.url)
                .resizable()
                .indicator(.activity)
                .scaledToFit()
                .scaleEffect(scale * gestureScale)
                .gesture(
                    MagnificationGesture()
                        .updating($gestureScale) { value, state, _ in
                            state = value
                        }
                        .onEnded { value in
                            scale *= value
                        }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FullScreenView(viewModel: FullScreenViewModel(url: MockedData.photo.urls.full!))
}
