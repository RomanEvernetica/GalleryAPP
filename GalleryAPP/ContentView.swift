//
//  ContentView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import FlowStacks
import SwiftUI

struct ContentView: View {
    @State var routes: Routes<MainRoute> = []

    var body: some View {
        FlowStack($routes, withNavigation: true) {
            MainScreenTabView()
                .flowDestination(for: MainRoute.self) { route in
                    if case let .fullScreen(vm) = route {
                        FullScreenView(viewModel: vm)
                    } else if case let .collection(vm) = route {
                        CollectionDetailView(viewModel: vm)
                    } else if case let .userProfile(vm) = route {
                        UserProfileView(viewModel: vm)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
