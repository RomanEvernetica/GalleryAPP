//
//  UnsplashCollection.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 10.04.2025.
//

import Foundation

struct UnsplashCollection: Codable, Identifiable {
    let id: String
    let title: String?
    let description: String?
    let totalPhotos: Int
    let coverPhoto: UnsplashPhoto?
    let user: UnsplashUser?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case totalPhotos = "total_photos"
        case coverPhoto = "cover_photo"
        case user
    }
}
