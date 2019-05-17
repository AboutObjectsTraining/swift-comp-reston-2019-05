// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Genre.swift instead.

import Foundation
import CoreData

open class _Genre: ManagedObject
{ 
    public struct Keys {
        public static let genreId = "genreId"
        public static let name = "name"
        public static let book = "book"
    }

    open class var entityName: String { return "Genre" }
    open class var fetchRequest: NSFetchRequest<Genre> { return NSFetchRequest(entityName: entityName) }

    @NSManaged open var genreId: String?
    @NSManaged open var name: String?
    @NSManaged open var book: Book?

    public required init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Genre.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
    }
}

extension _Genre {

}
