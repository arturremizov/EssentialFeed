//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Artur Remizov on 5.08.24.
//

import CoreData

final public class CoreDataFeedStore: FeedStore {
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "FeedStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            do {
                if let cacheEntity = try CacheEntity.find(in: context) {
                    completion(.found(feed: cacheEntity.localFeed, timestamp: cacheEntity.timestamp!))
                } else {
                    completion(.empty)
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            do {
                let cacheEnity = try CacheEntity.newUniqueInstance(in: context)
                cacheEnity.feed = FeedImageEntity.images(from: feed, in: context)
                cacheEnity.timestamp = timestamp
                
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func deleteCacheFeed(completion: @escaping DeletionCompletion) {
        perform { context in
            do {
                try CacheEntity.find(in: context)
                    .map(context.delete)
                    .map(context.save)
                
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    private func perform(_ action: @escaping (_ context: NSManagedObjectContext) -> Void) {
        let context = context
        context.perform { action(context) }
    }
}
