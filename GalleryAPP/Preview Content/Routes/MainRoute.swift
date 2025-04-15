//
//  MainRoute.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 08.04.2025.
//

import SwiftUI

enum MainRoute: Hashable, Equatable {
    case fullScreen(vm: GalleryItemViewModel)
    case collection(vm: CollectionDetailViewModel)
    case userProfile(vm: UserViewModel)

    static func == (lhs: MainRoute, rhs: MainRoute) -> Bool {
        switch (lhs, rhs) {
        case let (.fullScreen(lhsVM), .fullScreen(rhsVM)):
            return lhsVM == rhsVM
        case let (.collection(lhsVM), .collection(rhsVM)):
            return lhsVM == rhsVM
        case let (.userProfile(lhsVM), .userProfile(rhsVM)):
            return lhsVM == rhsVM
        default:
            return false
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
}
