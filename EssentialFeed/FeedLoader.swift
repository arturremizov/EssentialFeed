//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Artur Remizov on 20.05.23.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
