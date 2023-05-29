//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Artur Remizov on 29.05.23.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
