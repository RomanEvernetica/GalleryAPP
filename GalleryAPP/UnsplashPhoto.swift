//
//  UnsplashPhoto.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 03.04.2025.
//

import Foundation

struct UnsplashPhoto: Codable, Identifiable {
    let id: String
    let height: Int
    let width: Int
    let urls: ImageURLs


    private enum CodingKeys: String, CodingKey {
        case id
        case height
        case width
        case urls
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        height = try container.decode(Int.self, forKey: .height)
        width = try container.decode(Int.self, forKey: .width)

        urls = try container.decode(ImageURLs.self, forKey: .urls)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(height, forKey: .height)
        try container.encode(width, forKey: .width)
        try container.encode(urls, forKey: .urls)
    }
}

struct ImageURLs: Codable {
    var raw: URL?
    var full: URL?
    var regular: URL?
    var small: URL?
    var thumb: URL?
}
