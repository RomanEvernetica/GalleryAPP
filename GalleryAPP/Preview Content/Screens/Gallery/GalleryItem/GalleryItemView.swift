//
//  GalleryItemView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct GalleryItemView: View {
    private let viewModel: GalleryItemViewModel

    init(viewModel: GalleryItemViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        WebImage(url: viewModel.itemURL) { image in
            image.resizable()
        } placeholder: {
            Rectangle().foregroundColor(.gray)
        }
        .indicator(.activity)
        .transition(.fade(duration: 0.5))
    }
}

#Preview {
    GalleryItemView(viewModel: GalleryItemViewModel(item: MockedData.photo))
}
