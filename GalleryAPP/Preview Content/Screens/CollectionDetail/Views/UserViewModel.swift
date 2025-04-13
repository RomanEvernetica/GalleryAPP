//
//  UserViewModel.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 13.04.2025.
//

import Foundation

class UserViewModel {
    private let user: UnsplashUser

    var name: String? { user.name }
    var username: String { user.username }
    var imageURL: URL? { user.profileImage?.medium }

    init(user: UnsplashUser) {
        self.user = user
    }
}
