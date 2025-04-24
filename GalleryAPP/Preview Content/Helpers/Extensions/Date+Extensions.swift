//
//  Date+Extensions.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 24.04.2025.
//

import Foundation

extension Date {
    enum FormatType: String {
        case iso8160 = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        case postFormAttachment = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        case incomingFormat = "yyyy-MM-dd HH:mm:ss"
        case day = "dd"
        case month = "MMM"
        case time = "hh:mm aa"
        case hhmmaddMMMyyyy = "E, dd MMM, yyyy hh:mm aa"
        case dMMMyyyy = "MMM dd, yyyy" // Mar 24, 2021
        case MMMdd = "MMM dd"
        case yyyMMdd = "yyyMMdd"
        case HHmmss = "HHmmss"
        case yyyyMMdd = "yyyy-MM-dd"
        case hhmmss   = "HH:mm:ss"
        case hhmm   = "HH:mm"
        case filename = "ddHHmmss"
        case ddMMyyyy = "dd/MM/yyyy"
        // Birth day picker
        case dayMonth = "d-M"
        case ddMMMM = "d MMMM"

        case ddMMMMyyyy = "dd MMMM yyyy"
        // Not used yet
        case ddMMMyyyy = "dd MMM.yyyy"
        case MMddyyyy = "MM.dd.yyyy"
        case accurate = "SSS"
        case MMMdyyyy = "MMM d, yyy"
        case EMMMdyyyy = "E, MMM d, yyy"
    }

    func string(_ format: FormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}
