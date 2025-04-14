//
//  CollectionItemView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 11.04.2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct CollectionItemView: View {
    private let viewModel: CollectionItemViewModel

    init(viewModel: CollectionItemViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            WebImage(url: viewModel.url) { image in
                image.resizable()
            } placeholder: {
                Rectangle().foregroundColor(.gray)
            }
            .indicator(.activity)
            .transition(.fade(duration: 0.5))

            Rectangle()
                .fill(Color.black.opacity(0.5))

            if let title = viewModel.title {
                Text(title)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
}

#Preview {
    CollectionItemView(viewModel: CollectionItemViewModel(collection: MockedData.collection))
}
