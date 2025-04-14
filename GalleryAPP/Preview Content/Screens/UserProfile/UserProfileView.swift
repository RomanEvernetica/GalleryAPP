//
//  UserProfileView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 14.04.2025.
//

import SwiftUI

struct UserProfileView: View {
    enum Tab: String, Hashable, CaseIterable {
        case gallery = "Gallery"
        case collections = "Collections"
    }

    @EnvironmentObject var router: MainRouter
    @State private var selectedTab: Tab = .gallery
    private let viewModel: UserViewModel

    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            UserView(viewModel: viewModel)
                .padding(.horizontal)

            if let bio = viewModel.bio {
                Text(bio)
                    .padding(.horizontal)
            }

            HStack {
                Spacer()

                HStack {
                    Image(systemName: "photo.on.rectangle")
                    Text("\(viewModel.totalPhotos)")
                }

                Spacer()

                HStack {
                    Image(systemName: "folder")
                    Text("\(viewModel.totalCollections)")
                }

                Spacer()

                HStack {
                    Image(systemName: "heart")
                    Text("\(viewModel.totalLikes)")
                }

                Spacer()
            }

            VStack {
                HStack {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        Button(action: {
                            selectedTab = tab
                        }) {
                            Text(tab.rawValue)
                                .fontWeight(.medium)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(selectedTab == tab ? .white : .black)
                                .background(selectedTab == tab ? Color.black : Color.clear)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
                .background(Color(UIColor.systemGray6))

                UserProfileTabContentView(selectedTab: selectedTab, viewModel: viewModel)
            }
        }
        .navigationTitle(viewModel.name ?? viewModel.username)
        .toolbar {
            ToolbarItem {
                Button("", systemImage: "xmark") {
                    router.popToRoot()
                }
            }
        }
    }
}

#Preview {
    UserProfileView(viewModel: UserViewModel(user: MockedData.user))
}
