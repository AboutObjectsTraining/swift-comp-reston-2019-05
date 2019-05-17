// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Author.swift instead.

import Foundation
import CoreData

open class _Author: ManagedObject
{ 
    public struct Keys {
        public static let authorId = "authorId"
        public static let name = "name"
        public static let books = "books"
    }

    open class var entityName: String { return "Author" }
    open class var fetchRequest: NSFetchRequest<Author> { return NSFetchRequest(entityName: entityName) }

    @NSManaged open var authorId: NSNumber!
    @NSManaged open var name: String!
    @NSManaged open var books: NSOrderedSet

    public required init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Author.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
    }
}

// MARK: Generated accessors for `books`
extension _Author {
    @objc(insertObject:inBooksAtIndex:)
    @NSManaged public func insertIntoBooks(_ value: Book, at idx: Int)

    @objc(removeObjectFromBooksAtIndex:)
    @NSManaged public func removeFromBooks(at idx: Int)

    @objc(insertBooks:atIndexes:)
    @NSManaged public func insertIntoBooks(_ values: [Book], at indexes: NSIndexSet)

    @objc(removeBooksAtIndexes:)
    @NSManaged public func removeFromBooks(at indexes: NSIndexSet)

    @objc(replaceObjectInBooksAtIndex:withObject:)
    @NSManaged public func replaceResources(at idx: Int, with value: Book)

    @objc(replaceBooksAtIndexes:withBooks:)
    @NSManaged public func replaceResources(at indexes: NSIndexSet, with values: [Book])

    @objc(addBooksObject:)
    @NSManaged public func addToBooks(_ value: Book)

    @objc(removeBooksObject:)
    @NSManaged public func removeFromBooks(_ value: Book)

    @objc(addBooks:)
    @NSManaged public func addToBooks(_ value: NSOrderedSet)

    @objc(removeBooks:)
    @NSManaged public func removeFromBooks(_ value: NSOrderedSet)
}

extension _Author {

}
