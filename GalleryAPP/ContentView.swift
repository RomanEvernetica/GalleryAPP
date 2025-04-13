//
//  ContentView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var router: MainRouter

    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            MainScreenTabView()
                .navigationDestination(for: MainRoute.self) { route in
                    router.configure(route: route)
                }
        }
    }
}

#Preview {
    ContentView()
}
