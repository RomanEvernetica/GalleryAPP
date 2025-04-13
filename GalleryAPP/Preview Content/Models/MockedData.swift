//
//  MockedData.swift
//  GalleryAPP
//
//  Created by Eugene Shapovalov on 11.04.2025.
//

import Foundation

struct MockedData {
    static let photo = UnsplashPhoto(id: "yhhuhL9Z3ck",
                                     height: 4000,
                                     width: 3000,
                                     urls: ImageURLs(raw: URL(string: "https://plus.unsplash.com/premium_photo-1679171644551-fa852d06aabf?ixlib=rb-4.0.3"),
                                                     full: URL(string: "https://plus.unsplash.com/premium_photo-1679171644551-fa852d06aabf?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb"),
                                                     regular: URL(string: "https://plus.unsplash.com/premium_photo-1679171644551-fa852d06aabf?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max"),
                                                     small: URL(string: "https://plus.unsplash.com/premium_photo-1679171644551-fa852d06aabf?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max"),
                                                     thumb: URL(string: "https://plus.unsplash.com/premium_photo-1679171644551-fa852d06aabf?ixlib=rb-4.0.3&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max")),
                                     user: user)

    static let user = UnsplashUser(id: "2QBXDhqC2NI",
                                   username: "tsd_studio",
                                   name: "TSD Studio",
                                   profileImage: UserImages(small: URL(string:"https://images.unsplash.com/profile-1742242056308-9138a58f67bfimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=32&h=32"),
                                                            medium: URL(string:"https://images.unsplash.com/profile-1742242056308-9138a58f67bfimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=64&h=64"),
                                                            large: URL(string:"https://images.unsplash.com/profile-1742242056308-9138a58f67bfimage?ixlib=rb-4.0.3&crop=faces&fit=crop&w=128&h=128")),
                                   bio: "Open for work.\r\nSay hi@shubhamdhage.com",
                                   links: nil,
                                   location: nil,
                                   portfolioURL: nil,
                                   totalCollections: 25,
                                   totalLikes: 0,
                                   totalPhotos: 1029)

    static let collection = UnsplashCollection(id: "bpIy456l5HQ",
                                               title: "Market Volatility ",
                                               description: "A collection showcasing the rise and fall of the stock market. ",
                                               totalPhotos: 40,
                                               coverPhoto: photo,
                                               user: UnsplashUser(id: "iwi9-4OXLYY",
                                                                  username: "unsplashplus",
                                                                  name: "Unsplash+ Collections",
                                                                  profileImage: UserImages(small: URL(string: "https://images.unsplash.com/profile-1714421769490-6918cb0c83a9image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=32&h=32"),
                                                                                           medium: URL(string: "https://images.unsplash.com/profile-1714421769490-6918cb0c83a9image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=64&h=64"),
                                                                                           large: URL(string: "https://images.unsplash.com/profile-1714421769490-6918cb0c83a9image?ixlib=rb-4.0.3&crop=faces&fit=crop&w=128&h=128")),
                                                                  bio: nil,
                                                                  links: nil,
                                                                  location: nil,
                                                                  portfolioURL: nil,
                                                                  totalCollections: 210,
                                                                  totalLikes: 347,
                                                                  totalPhotos: 0))
}
