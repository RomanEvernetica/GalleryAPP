//
//  HTTPLogger.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 10.04.2025.
//

import Foundation

enum HTTPLogger {
    private static var requestStartTimes: [String: Date] = [:]

    static func logRequest(id: String, url: String, method: String, headers: [String: String], body: Data?) {
        requestStartTimes[id] = Date()

        print("\n⬆️ [REQUEST]")
//        print("⬆️ REQUEST ID: \(id)")
        print("⬆️ REQUEST URL: \(url)")
        print("⬆️ REQUEST Method: \(method)")
        print("⬆️ REQUEST Headers: \(headers)")

        if let body = body {
            let bodyString = String(data: body, encoding: String.Encoding.utf8) ?? ""
            print("⬆️ REQUEST Body:\n\(bodyString)")
        }
    }

    static func logResponse(id: String, data: Data?, statusCode: Int?) {
        let endTime = Date()
        let duration = requestStartTimes[id].map { String(format: "%.2f", endTime.timeIntervalSince($0)) } ?? "N/A"
        requestStartTimes[id] = nil

        print("\n⬇️ [RESPONSE]")
//        print("⬇️ RESPONSE ID: \(id)")
        if let statusCode = statusCode {
            let im = 200..<300 ~= statusCode ? "✅" : "❌"
            print("\(im) RESPONSE Status: \(statusCode)")
        }
        print("⬇️ ⏱ RESPONSE Duration: \(duration) sec")

        if let data = data {
            print("⬇️ RESPONSE Data: \(String(decoding: data, as: UTF8.self))")
        }
    }

    static func logError(id: String, _ error: Error) {
        print("\n❌ [ERROR]")
//        print("🔹 ID: \(id)")
        print("🔺 \(error.localizedDescription)")
    }
}
