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
    case searchPhotos(query: String, page: Int, collections: [Int])
    case getPhoto(id: String)

    case getUser(username: String)
    case getUserPhotos(username: String, page: Int)
    case getUserCollections(username: String, page: Int)

    case getCollections(page: Int)
    case getCollectionPhotos(id: String, page: Int)
    case getCollection(id: String)
    case getCollectionRelatedCollections(id: String)
    case searchCollections(query: String, page: Int)


    var url: String {
        baseUrl + path
    }

    var method: HTTPMethod {
        switch self {
        case .getPhotos,
             .searchPhotos,
             .getPhoto,
             .getUser,
             .getUserPhotos,
             .getUserCollections,
             .getCollections,
             .getCollectionPhotos,
             .getCollection,
             .getCollectionRelatedCollections,
             .searchCollections:
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
        case let .searchPhotos(query, page, collections):
            var path = "/search/photos?page=\(page)&query=\(query)"
            if !collections.isEmpty {
                path += "&collections=\(collections.map(\.description).joined(separator: ","))"
            }
            return path
        case let .getPhoto(id):
            return "/photos/\(id)"
        case let .getUser(username):
            return "/users/\(username)"
        case let .getUserPhotos(username, page):
            return "/users/\(username)/photos?page=\(page)"
        case let .getUserCollections(username, page):
            return "/users/\(username)/collections?page=\(page)"
        case let .getCollections(page):
            return "/collections?page=\(page)"
        case let .getCollectionPhotos(id, page):
            return "/collections/\(id)/photos?page=\(page)"
        case let .getCollection(id):
            return "/collections/\(id)"
        case let .getCollectionRelatedCollections(id):
            return "/collections/\(id)/related"
        case .searchCollections(query: let query, page: let page):
            return "/search/collections?page=\(page)&query=\(query)"
        }
    }
}
