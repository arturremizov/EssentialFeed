//
//  NSManagedObject+Extension.swift
//  EssentialFeed
//
//  Created by Artur Remizov on 7.08.24.
//

import CoreData

internal extension NSManagedObject {
    static func find(in context: NSManagedObjectContext) throws -> Self? {
        let request = Self.fetchRequest()
        return try context.fetch(request).first as? Self
    }
}
