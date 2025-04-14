//
//  UserProfileTabContentView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 14.04.2025.
//

import SwiftUI

struct UserProfileTabContentView: View {
    let selectedTab: UserProfileView.Tab

    private let viewModel: UserViewModel

    init(selectedTab: UserProfileView.Tab, viewModel: UserViewModel) {
        self.selectedTab = selectedTab
        self.viewModel = viewModel
    }

    var body: some View {
        Group {
            switch selectedTab {
            case .gallery:
                GalleryView(viewModel: GalleryViewModel(flow: .user(username: viewModel.username)))
            case .collections:
                CollectionsView(viewModel: .init(flow: .user(username: viewModel.username)))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    UserProfileTabContentView(selectedTab: .gallery,
                              viewModel: UserViewModel(user: MockedData.user))
}
