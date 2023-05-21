//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Artur Remizov on 20.05.23.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
