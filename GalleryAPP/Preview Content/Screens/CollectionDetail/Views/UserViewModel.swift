//
//  UserViewModel.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 13.04.2025.
//

import Foundation

class UserViewModel: Equatable {
    static func == (lhs: UserViewModel, rhs: UserViewModel) -> Bool {
        return lhs.username == rhs.username
    }

    private let user: UnsplashUser

    var name: String? { user.name }
    var username: String { user.username }
    var imageURL: URL? { user.profileImage?.medium }
    var bio: String? { user.bio }

    var totalCollections: Int { user.totalCollections }
    var totalLikes: Int { user.totalLikes }
    var totalPhotos: Int { user.totalPhotos }

    init(user: UnsplashUser) {
        self.user = user
    }
}
