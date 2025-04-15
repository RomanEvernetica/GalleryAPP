//
//  Router.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 15.04.2025.
//

import SwiftUI

protocol Router {
    associatedtype T: Hashable & Equatable
    associatedtype SomeView = View

    var navigationPath: [T] { get set }

    func navigateTo(route: T)

    func pop()
    func popToRoot()

    func popTo(route: T)

    func switchTo(route: T)

    func navigateOrPopTo(route: T)

    @ViewBuilder
    func configure(route: T) -> SomeView
}

class BaseRouter<U: Hashable & Equatable>: Router, ObservableObject {
    typealias T = U

    @Published var navigationPath: [T] = []

    @ViewBuilder
    func configure(route: T) -> some View {
        fatalError("This method must be overridden by subclass")
    }

    func navigateTo(route: T) {
        navigationPath.append(route)
    }

    func pop() {
        navigationPath.removeLast()
    }

    func popToRoot() {
        navigationPath.removeAll()
    }

    func popTo(route: T) {
        if let index = navigationPath.firstIndex(of: route) {
            navigationPath = Array(navigationPath[...index])
        }
    }

    func switchTo(route: T) {
        if let last = navigationPath.last {
            navigationPath.replace([last], with: [route])
        }
    }

    func navigateOrPopTo(route: T) {
        if navigationPath.contains(route) {
            popTo(route: route)
        } else {
            navigateTo(route: route)
        }
    }
}
