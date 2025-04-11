//
//  MainScreenTabView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 10.04.2025.
//

import SwiftUI

struct MainScreenTabView: View {
    enum Tab: Hashable {
        case gallery
        case collections
    }

    @State var selectedTab: Tab = .gallery
    @State var searchText: String = ""

    var body: some View {
        TabView(selection: $selectedTab) {
            GalleryView()
                .tabItem {
                    Label("Gallery", systemImage: "photo.on.rectangle")
                }
                .tag(Tab.gallery)
            GalleryView()
                .tabItem {
                    Label("Collections", systemImage: "folder")
                }
                .tag(Tab.collections)
        }
    }
}

#Preview {
    MainScreenTabView()
}
