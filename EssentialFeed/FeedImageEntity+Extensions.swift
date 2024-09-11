//
//  FeedImageEntity+Extensions.swift
//  EssentialFeed
//
//  Created by Artur Remizov on 19.08.24.
//

import CoreData

internal extension FeedImageEntity {
    
    static func images(from feed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        let entities = feed.map { localFeedImage in
            let entity = FeedImageEntity(context: context)
            entity.id = localFeedImage.id
            entity.imageDescription = localFeedImage.description
            entity.location = localFeedImage.location
            entity.url = localFeedImage.url
            return entity
        }
        return NSOrderedSet(array: entities)
    }
}
