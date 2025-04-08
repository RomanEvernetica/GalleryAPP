//
//  Endpoint.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 08.04.2025.
//

import Alamofire
import Foundation

struct APPConstants {
    static let accessKey = "xKHzSiDBKxy4leBpc_khVaBQniLQ2S9IgfyJ-VzBR2Q"
    static let baseURL = "https://api.unsplash.com"
}

protocol Endpoint {
    var url: String { get }
    var method: Alamofire.HTTPMethod { get }
    var params: Parameters? { get }
    var headers: HTTPHeaders { get }
}

extension Endpoint {
    var baseUrl: String {
        return APPConstants.baseURL
    }

    var headers: HTTPHeaders {
        return HTTPHeaders([autorizationHeader, verHeader])
    }
}

extension Endpoint {
    var autorizationHeader: HTTPHeader {
        return HTTPHeader.authorization("Client-ID \(APPConstants.accessKey)")
    }

    var verHeader: HTTPHeader {
        return HTTPHeader(name: "Accept-Version", value: "v1")
    }
}
