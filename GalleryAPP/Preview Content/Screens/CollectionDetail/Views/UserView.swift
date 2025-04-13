//
//  UserView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 11.04.2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserView: View {
    private let viewModel: UserViewModel

    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack(spacing: 20) {
            WebImage(url: viewModel.imageURL) { image in
                image.resizable()
            } placeholder: {
                Image(systemName: "person.circle")
            }
            .mask(Circle())
            .frame(width: 50, height: 50)
            .overlay {
                Circle().stroke(.black, lineWidth: 1)
            }

            VStack(alignment: .leading) {
                if let name = viewModel.name {
                    Text(name)
                        .font(.headline)
                }
                Text(viewModel.username)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    UserView(viewModel: UserViewModel(user: MockedData.user))
}
