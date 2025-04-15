//
//  ContentView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import FlowStacks
import SwiftUI

struct ContentView: RootView {
    @State var routes: Routes<MainRoute> = []

    var body: some View {
        FlowStack($routes, withNavigation: true) {
            MainScreenTabView()
                .flowDestination(for: MainRoute.self) { route in
                    configure(route: route)
                }
        }
    }
}

extension ContentView {
    @ViewBuilder
    func configure(route: MainRoute) -> some View {
        switch route {
        case let .fullScreen(vm):
            FullScreenView(viewModel: vm)
        case let .collection(vm):
            CollectionDetailView(viewModel: vm)
        case let .userProfile(vm):
            UserProfileView(viewModel: vm)
        }
    }
}

#Preview {
    ContentView()
}
