//
//  UnsplashPhoto.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import Foundation

struct UnsplashPhoto: Codable {
    let id: String
    let height: Int
    let width: Int
    let urls: ImageURLs
    let user: UnsplashUser
}

struct ImageURLs: Codable {
    var raw: URL?
    var full: URL?
    var regular: URL?
    var small: URL?
    var thumb: URL?
}
