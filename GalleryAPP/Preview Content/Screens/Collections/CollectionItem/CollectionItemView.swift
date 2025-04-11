//
//  CollectionItemView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 11.04.2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct CollectionItemView: View {
    private let url: URL?
    private var title: String?

    init(url: URL?, title: String?) {
        self.url = url
        self.title = title
    }

    init(item: UnsplashCollection) {
        self.url = item.coverPhoto?.urls.small
        self.title = item.title
    }

    var body: some View {
        ZStack {
            WebImage(url: url) { image in
                image.resizable()
            } placeholder: {
                Rectangle().foregroundColor(.gray)
            }
            .indicator(.activity)
            .transition(.fade(duration: 0.5))

            if let title {
                Rectangle()
                    .fill(Color.black.opacity(0.5))

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
    CollectionItemView(url: URL(string: "https://nokiatech.github.io/heif/content/images/ski_jump_1440x960.heic"),
                       title: "Title")
}
