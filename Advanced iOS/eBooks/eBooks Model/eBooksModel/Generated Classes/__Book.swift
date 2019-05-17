// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Book.swift instead.

import Foundation
import CoreData

open class _Book: ManagedObject
{ 
    public struct Keys {
        public static let averageRating = "averageRating"
        public static let bookId = "bookId"
        public static let price = "price"
        public static let ratingCount = "ratingCount"
        public static let releaseDate = "releaseDate"
        public static let synopsis = "synopsis"
        public static let thumbnailUrl = "thumbnailUrl"
        public static let title = "title"
        public static let author = "author"
    }

    public struct BookUserInfo {
        public static let jsonKeyPath = "jsonKeyPath"
    }

    open class var entityName: String { return "Book" }
    open class var fetchRequest: NSFetchRequest<Book> { return NSFetchRequest(entityName: entityName) }

    @NSManaged open var averageRating: NSNumber?
    @NSManaged open var bookId: NSNumber!
    @NSManaged open var price: NSDecimalNumber?
    @NSManaged open var ratingCount: NSNumber?
    @NSManaged open var releaseDate: AnyObject?
    @NSManaged open var synopsis: String?
    @NSManaged open var thumbnailUrl: AnyObject?
    @NSManaged open var title: String!
    @NSManaged open var author: Author?

    public required init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Book.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
    }
}

extension _Book {

}
