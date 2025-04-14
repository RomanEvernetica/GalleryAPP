//
//  BottomSheetMenuView.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 14.04.2025.
//

import SwiftUI

struct BottomSheetMenuItem: Identifiable {
    var id = UUID()
    let title: String
    let systemImage: String?
    let image: Image?
    let action: EmptyBlock
}

struct BottomSheetMenuView: View {
    @Environment(\.dismiss) private var dismiss

    let items: [BottomSheetMenuItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(items) { item in
                Button {
                    item.action()
                    dismiss()
                } label: {
                    if let systemImage = item.systemImage {
                        Label(item.title, systemImage: systemImage)
                            .padding()
                    } else if let image = item.image {
                        Label {
                            Text(item.title)
                        } icon: {
                            image
                        }
                        .padding()
                    } else {
                        Text(item.title)
                            .padding()
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    BottomSheetMenuView(items: [BottomSheetMenuItem(title: "Menu item",
                                                    systemImage: "xmark",
                                                    image: nil,
                                                    action: {
        print("BUTTON TAPPED")
    })])
}
