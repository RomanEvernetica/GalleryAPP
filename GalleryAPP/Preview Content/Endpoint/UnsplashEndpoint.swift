//
//  UnsplashEndpoint.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 08.04.2025.
//

import Alamofire
import Foundation

enum UnsplashEndpoint: Endpoint {
    case getPhotos(page: Int)
    case searchPhotos(query: String, page: Int)
    case getPhoto(id: String)

    var url: String {
        baseUrl + path
    }

    var method: HTTPMethod {
        switch self {
        case .getPhotos,
             .searchPhotos,
             .getPhoto:
            return .get
        }
    }

    var params: Parameters? {
        return nil
    }

    private var path: String {
        switch self {
        case let .getPhotos(page):
            return "/photos?page=\(page)"
        case let .searchPhotos(query, page):
            return "/search/photos?page=\(page)&query=\(query)"
        case let .getPhoto(id):
            return "/photos/\(id)"
        }
    }
}
