//
//  MainRouter.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 08.04.2025.
//

import SwiftUI

enum MainRoute: Hashable {
    case fullScreen(url: URL)
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
        }
    }
}
