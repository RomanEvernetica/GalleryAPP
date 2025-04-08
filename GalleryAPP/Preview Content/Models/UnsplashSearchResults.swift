//
//  UnsplashSearchResults.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 08.04.2025.
//

import Foundation

struct UnsplashSearchResults: Codable {
    let total: Int
    let totalPages: Int
    let results: [UnsplashPhoto]

    enum CodingKeys: String, CodingKey {
        case total, results
        case totalPages = "total_pages"
    }
}
