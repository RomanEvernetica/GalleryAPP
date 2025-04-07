//
//  FullScreenView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 04.04.2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct FullScreenView: View {
    private let url: URL

    @State private var scale: CGFloat = 1.0
    @GestureState private var gestureScale: CGFloat = 1.0

    init(url: URL) {
        self.url = url
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            WebImage(url: url)
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
    FullScreenView(url: URL(string: "https://nokiatech.github.io/heif/content/images/ski_jump_1440x960.heic")!)
}
