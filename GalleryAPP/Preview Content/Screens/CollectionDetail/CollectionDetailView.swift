//
//  CollectionDetailView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 11.04.2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct CollectionDetailView: View {
    @ObservedObject private var viewModel: CollectionDetailViewModel
    @EnvironmentObject var router: MainRouter

    init(viewModel: CollectionDetailViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ZStack {
                WebImage(url: viewModel.collection.coverPhoto?.urls.regular)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                
                Rectangle()
                    .fill(Color.black.opacity(0.5))
                    .frame(height: 200)
                    .clipped()
                
                VStack {
                    if let title = viewModel.collection.title {
                        Text(title)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    HStack {
                        Image(systemName: "photo.on.rectangle")
                        Text("\(viewModel.collection.totalPhotos)")
                    }
                }
                .foregroundColor(.white)
            }
            
            if let user = viewModel.collection.user {
                let vm = UserViewModel(user: user)
                UserView(viewModel: vm)
                    .padding(.horizontal, 16)
                    .onTapGesture {
                        router.navigateTo(route: .userProfile(vm: vm))
                    }
            }
            
            if let description = viewModel.collection.description {
                Text(description)
                    .font(.body)
                    .padding(.horizontal, 16)
            }
            
            GalleryScreenView(viewModel: viewModel.galleryViewModel)
        }
    }
}

#Preview {
    CollectionDetailView(viewModel: CollectionDetailViewModel(collection: MockedData.collection))
}
