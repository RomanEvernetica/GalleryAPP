//
//  MainRouter.swift
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

class MainRouter: ObservableObject {
    @Published var navigationPath = [MainRoute]()

    func navigateTo(route: MainRoute) {
        navigationPath.append(route)
    }

    func pop() {
        navigationPath.removeLast()
    }

    func popToRoot() {
        navigationPath.removeAll()
    }

    func popTo(route: MainRoute) {
        if let index = navigationPath.firstIndex(of: route) {
            navigationPath = Array(navigationPath[...index])
        }
    }

    func switchTo(route: MainRoute) {
        if let last = navigationPath.last {
            navigationPath.replace([last], with: [route])
        }
    }

    func navigateOrPopTo(route: MainRoute) {
        if navigationPath.contains(route) {
            popTo(route: route)
        } else {
            navigateTo(route: route)
        }
    }

    @ViewBuilder
    func configure(route: MainRoute) -> some View {
        switch route {
        case let .fullScreen(vm):
            FullScreenView(viewModel: vm)
        case let .collection(vm):
            CollectionDetailView(viewModel: vm)
        case let .userProfile(vm):
            UserProfileView(viewModel: vm)
        }
    }
}
