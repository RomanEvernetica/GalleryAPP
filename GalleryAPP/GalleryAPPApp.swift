//
//  GalleryAPPApp.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import SwiftUI

@main
struct GalleryAPPApp: App {
    @ObservedObject var router = MainRouter()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
        }
    }
}
