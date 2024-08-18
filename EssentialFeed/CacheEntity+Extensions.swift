//
//  CacheEntity+Extensions.swift
//  EssentialFeed
//
//  Created by Artur Remizov on 19.08.24.
//

import CoreData

internal extension CacheEntity {
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> CacheEntity {
        if let foundCacheEntity = try CacheEntity.find(in: context) {
            context.delete(foundCacheEntity)
        }
        let newCacheEntity = CacheEntity(context: context)
        context.insert(newCacheEntity)
        return newCacheEntity
    }
    
    var localFeed: [LocalFeedImage] {
        return feed!
            .map { $0 as! FeedImageEntity }
            .map { LocalFeedImage(id: $0.id!, description: $0.imageDescription, location: $0.location, url: $0.url!) }
    }
}
