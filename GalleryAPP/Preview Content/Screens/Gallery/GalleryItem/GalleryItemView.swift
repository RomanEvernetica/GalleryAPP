//
//  GalleryItemView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct GalleryItemView: View {
    private let url: URL?

    init(url: URL?) {
        self.url = url
    }

    init(item: UnsplashPhoto) {
        self.url = item.urls.small
    }

    var body: some View {
        WebImage(url: url) { image in
            image.resizable()
        } placeholder: {
            Rectangle().foregroundColor(.gray)
        }
        .indicator(.activity)
        .transition(.fade(duration: 0.5))
    }
}

#Preview {
    GalleryItemView(url: URL(string: "https://nokiatech.github.io/heif/content/images/ski_jump_1440x960.heic"))
}
