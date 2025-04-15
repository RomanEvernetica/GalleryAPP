//
//  RootView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 15.04.2025.
//

import FlowStacks
import SwiftUI

protocol RootView: View {
    associatedtype T: Hashable & Equatable
    associatedtype SomeView: View

    @ViewBuilder
    func configure(route: T) -> SomeView
}
