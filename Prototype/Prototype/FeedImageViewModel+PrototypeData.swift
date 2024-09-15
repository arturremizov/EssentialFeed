//
//  FeedImageViewModel+PrototypeData.swift
//  Prototype
//
//  Created by Artur Remizov on 12.09.24.
//

import Foundation

extension FeedImageViewModel {
    static var prototypeFeed: [FeedImageViewModel] {
        return [
            FeedImageViewModel(
                location: "Statue of Liberty\nNew York, USA",
                imageName: "image-0",
                description: "The Statue of Liberty, located on Liberty Island in New York Harbor, is one of the most iconic symbols of freedom and democracy in the world. Gifted by France in 1886, the statue stands as a beacon of hope to immigrants arriving in America, representing liberty, opportunity, and the pursuit of a better life. Designed by French sculptor Frédéric Auguste Bartholdi, it stands at 305 feet tall and has welcomed millions of visitors over the years. The statue's torch, raised high above her head, and the broken chains at her feet signify enlightenment and the end of oppression, making it a powerful symbol in American history."
            ),
            FeedImageViewModel(
                location: nil,
                imageName: "image-1",
                description: nil
            ),
            FeedImageViewModel(
                location: "Colosseum\nRome, Italy",
                imageName: "image-2",
                description: nil
            ),
            FeedImageViewModel(
                location: nil,
                imageName: "image-3",
                description: "An enchanting view of the Northern Lights illuminating the night sky."
            ),
            FeedImageViewModel(
                location: "Garth Pier\nNorth Wales",
                imageName: "image-4",
                description: "Garth Pier, located in Bangor, North Wales, is a scenic Victorian pier extending 1,500 feet into the Menai Strait, offering picturesque views and a tranquil promenade experience."
            ),
            FeedImageViewModel(
                location: nil,
                imageName: "image-5",
                description: nil
            ),
            FeedImageViewModel(
                location: "Santorini, Greece",
                imageName: "image-6",
                description: "The stunning white-washed buildings with blue domes set against the backdrop of the Aegean Sea make Santorini an iconic travel destination."
            ),
            FeedImageViewModel(
                location: nil,
                imageName: "image-7",
                description: "A peaceful day at the lake, perfect for reflection and relaxation."
            ),
            FeedImageViewModel(
                location: "Shibuya Crossing\nTokyo, Japan",
                imageName: "image-8",
                description: nil
            ),
            FeedImageViewModel(
                location: nil,
                imageName: "image-9",
                description: "Enjoying a serene sunset over the rolling hills."
            )
        ]
    }

}
