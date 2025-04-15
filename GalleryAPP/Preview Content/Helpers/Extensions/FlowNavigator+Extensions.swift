//
//  FlowNavigator+Extensions.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 15.04.2025.
//

import FlowStacks
import Foundation

extension FlowNavigator {
    func navigateOrPopTo(route: Screen) where Screen: Equatable {
        if routes.contains(where: { $0.screen == route }) {
            popTo(route)
        } else {
            push(route)
        }
    }
}
