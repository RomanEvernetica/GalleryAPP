//
//  FullScreenView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 04.04.2025.
//

import SwiftUI
//import SwiftUIX
import SDWebImageSwiftUI

struct FullScreenView: View {
    private let viewModel: GalleryItemViewModel

    @EnvironmentObject var router: MainRouter
    @State private var scale: CGFloat = 1.0
    @GestureState private var gestureScale: CGFloat = 1.0

    @State private var sheetHeight: CGFloat = 0
    @State private var isSheetPresented = false

    private var bottomItems: [BottomSheetMenuItem] {
        return [BottomSheetMenuItem(title: "Show owner profile",
                                    systemImage: "person.circle",
                                    image: nil,
                                    action: {
            guard let user = viewModel.user else { return }
            router.navigateOrPopTo(route: .userProfile(vm: UserViewModel(user: user)))
        })]
    }

    init(viewModel: GalleryItemViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            WebImage(url: viewModel.fullImageURL)
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
        .toolbar {
            ToolbarItem {
                Button("", systemImage: "ellipsis") {
                    isSheetPresented = true
                }
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            BottomSheetMenuView(items: bottomItems)
                .readHeight()
                .onPreferenceChange(HeightPreferenceKey.self) { height in
                    if let height {
                        sheetHeight = height
                    }
                }
                .presentationDetents([.height(sheetHeight)])
        }
    }
}

#Preview {
    FullScreenView(viewModel: GalleryItemViewModel(item: MockedData.photo))
}
