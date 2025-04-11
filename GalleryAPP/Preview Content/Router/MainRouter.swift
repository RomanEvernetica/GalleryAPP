//
//  MainRouter.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 08.04.2025.
//

import SwiftUI

enum MainRoute: Hashable, Equatable {
    case fullScreen(url: URL)
    case collection(item: UnsplashCollection)

    static func == (lhs: MainRoute, rhs: MainRoute) -> Bool {
        switch (lhs, rhs) {
        case (.fullScreen, .fullScreen):
            return true
        case (.collection, .collection):
            return true
        default:
            return false
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
}

class MainRouter: ObservableObject {
    @Published var navigationPath = NavigationPath()

    func navigateTo(route: MainRoute) {
        navigationPath.append(route)
    }
    
    @ViewBuilder
    func configure(route: MainRoute) -> some View {
        switch route {
        case let .fullScreen(url):
            FullScreenView(url: url)
        case let .collection(item):
            Text(item.title ?? "Gallery item")
        }
    }
}
