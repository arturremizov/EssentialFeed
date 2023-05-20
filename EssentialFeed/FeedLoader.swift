//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Artur Remizov on 20.05.23.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
