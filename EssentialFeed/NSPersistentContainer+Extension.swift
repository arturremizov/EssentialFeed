//
//  NSPersistentContainer+Extension.swift
//  EssentialFeed
//
//  Created by Artur Remizov on 5.08.24.
//

import CoreData

internal extension NSPersistentContainer {
    
    enum Error: LocalizedError {
        case failedToFindModelURL(modelName: String)
        case failedToLoadModel(modelURL: URL)
        
        var errorDescription: String? {
            switch self {
            case .failedToFindModelURL(let modelName):
                return "Failed to find model URL for model named \(modelName)"
            case .failedToLoadModel(let modelURL):
                return "Failed to load model at URL: \(modelURL)"
            }
        }
    }
    
    static func load(modelName: String, url: URL, in bundle: Bundle) throws -> NSPersistentContainer {
        guard let modelURL = bundle.url(forResource: modelName, withExtension: "momd") else {
            throw Error.failedToFindModelURL(modelName: modelName)
        }
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            throw Error.failedToLoadModel(modelURL: modelURL)
        }
        let container = NSPersistentContainer(name: modelName, managedObjectModel: managedObjectModel)

        let descriptor = NSPersistentStoreDescription(url: url)
        container.persistentStoreDescriptions = [descriptor]
        
        let semaphore = DispatchSemaphore(value: 0)
        var loadError: Swift.Error?
        
        container.loadPersistentStores { _, error in
            loadError = error
            semaphore.signal()
        }
        semaphore.wait()
        
        if let loadError {
            throw loadError
        }
        return container
    }
}
