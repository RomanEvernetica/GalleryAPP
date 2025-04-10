//
//  UnsplashUser.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 10.04.2025.
//

import Foundation

struct UnsplashUser: Codable {
    let id: String
    let username: String
    let name: String?
    let profileImage: UserImages?
    let bio: String?
    let links: UserLinks?
    let location: String?
    let portfolioURL: URL?
    let totalCollections: Int
    let totalLikes: Int
    let totalPhotos: Int

    private enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case profileImage = "profile_image"
        case bio
        case links
        case location
        case portfolioURL = "portfolio_url"
        case totalCollections = "total_collections"
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
    }
}

struct UserImages: Codable {
    let small: URL?
    let medium: URL?
    let large: URL?
}

struct UserLinks: Codable {
    let html: URL?
    let photos: URL?
    let likes: URL?
    let portfolio: URL?
}
