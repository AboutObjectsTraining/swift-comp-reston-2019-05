// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest
import CoreData
@testable import EbooksModel

private var model: NSManagedObjectModel! =
    NSManagedObjectModel.mergedModel(from: [Bundle(for: Book.self)])

class ManagedObjectsSubclassTests: XCTestCase
{
    var container: NSPersistentContainer!
    var context: NSManagedObjectContext { return container.viewContext }

    // NOTE: creating multiple instances of the same model causes issues.
    //
    //    lazy var model: NSManagedObjectModel! =
    //        NSManagedObjectModel.mergedModel(from: [Bundle(for: Book.self)])
    
    override func setUp() {
        super.setUp()
        container = NSPersistentContainer(name: storeName,
                                          managedObjectModel: model)
        container.loadPersistentStores { store, error in
            print(error ?? "Persistent store loaded:\n\(store)")
        }
    }
    
    override func tearDown() {
        print()
        if let dbUrl = container.persistentStoreDescriptions.first?.url,
            FileManager.default.fileExists(atPath: dbUrl.path) {
            try! container.persistentStoreCoordinator
                .destroyPersistentStore(at: dbUrl, ofType: "sqlite", options: nil)
        }
        super.tearDown()
    }
}

// MARK: Inserting, Deleting, and Counting
extension ManagedObjectsSubclassTests
{
    func testInsertAuthor() {
        let author = Author(context: container.viewContext)
        XCTAssertTrue(container.viewContext.registeredObjects.contains(author))
    }
    
    func testDeleteAuthor() {
        let author1 = Author(context: context)
        author1.name = "A"
        let author2 = Author(context: context)
        author2.name = "B"
        XCTAssertFalse(author1.isDeleted)
        XCTAssertEqual(context.insertedObjects.count, 2)
        XCTAssertEqual(context.registeredObjects.count, 2)
        XCTAssertEqual(context.deletedObjects.count, 0)
        
        // Calling `delete` marks author1 as deleted. Note, however, that author1 remains in
        // the insertedObjects and registeredObjects arrays pending a call to `save`.
        context.delete(author1)
        XCTAssertTrue(author1.isDeleted)
        XCTAssertEqual(context.insertedObjects.count, 2)
        XCTAssertEqual(context.registeredObjects.count, 2)
        XCTAssertEqual(context.deletedObjects.count, 1)
        
        try! context.save()
        XCTAssertEqual(context.insertedObjects.count, 0)
        XCTAssertEqual(context.registeredObjects.count, 1)
        XCTAssertEqual(context.deletedObjects.count, 0)
    }
    
    func testCountQuery() {
        let author1 = Author(context: context)
        author1.name = "B"
        
        try! context.save()
        XCTAssertEqual(context.registeredObjects.count, 1)
        XCTAssertEqual(try! context.count(for: Author.fetchRequest()), 1)
        
        // Calling `reset` removes all managed objects from the context.
        context.reset()
        XCTAssertEqual(context.registeredObjects.count, 0)
        XCTAssertEqual(try! context.count(for: Author.fetchRequest()), 1)
        
        let author2 = Author(context: context)
        author2.name = "C"
        XCTAssertEqual(context.registeredObjects.count, 1)
        XCTAssertEqual(try! context.count(for: Author.fetchRequest()), 2)
    }
}

// MARK: Saving and Fetching
extension ManagedObjectsSubclassTests
{
    func testSaveAuthor() {
        let author = Author(context: context)
        XCTAssertFalse(author.hasPersistentChangedValues)
        
        author.iTunesId = 123
        author.name = "C"
        author.rating = 2
        XCTAssertTrue(author.hasPersistentChangedValues)

        let temporaryId = author.objectID
        print("temporary ID: \(temporaryId)")
        
        if author.hasPersistentChangedValues {
            do {
                try context.save()
            }
            catch let error {
                XCTFail("Unable to save author due to error: \(error)")
            }
        }
        
        let persistentId = author.objectID
        print("persistent ID: \(persistentId)")
        XCTAssertNotEqual(temporaryId, persistentId)
    }
    
    func testFetchAuthor() {
        let iTunesId = 456
        let author1 = Author(dictionary: ["iTunesId": iTunesId, "name": "F", "rating": 1], context: context)
        do {
            try context.save()
        }
        catch let error {
            XCTFail("Unable to save author, error was: \(error)")
        }
        
        context.reset();
        
        do {
            let result = try context.fetch(Author.fetchRequest()) as! [Author]
            XCTAssertFalse(result.first! === author1)
            XCTAssertEqual(result.first!.objectID, author1.objectID)
            XCTAssertEqual(context.insertedObjects.count, 0)
            XCTAssertEqual(context.registeredObjects.count, 1)
        }
        catch let error {
            XCTFail("Unable to fetch previously saved author, error was: \(error)")
        }
    }
}

// MARK: Nested Books
extension ManagedObjectsSubclassTests
{
    func testManuallyAddBooksToAuthor() {
        let author = Author(context: context)
        author.name = "A"
        let book1 = Book(context: context)
        book1.title = "B"
        let book2 = Book(context: context)
        book2.title = "C"
        
        // Use generated KVC accessors to manage books
        author.addToBooks(book1)
        author.addToBooks(book2)
        
        // KVC accessors take care of behind-the-scenes details, such as setting inverse relationships
        XCTAssertEqual(book1.author, author)
        XCTAssertEqual(context.insertedObjects.count, 3)
        
        do {
            try context.save()
        }
        catch let error {
            XCTFail("Unable to save author due to error: \(error)")
        }
        
        let savedBooksCount = try! context.count(for: Book.fetchRequest())
        XCTAssertEqual(savedBooksCount, author.books!.count)
    }
    
    var authorAndBooksInfo: [String: Any] {
        return ["iTunesId": 678, "name": "H", "rating": 4, "books": [
            ["iTunesId": 987, "title": "Book 1", "year": 1999],
            ["iTunesId": 876, "title": "Book 2", "year": 2012]]
        ]
    }
    
    func testSaveAuthorAndFetchBooks() {
        // Initialize author and nested books with a dictionary
        let author = Author(dictionary: authorAndBooksInfo, context: context)
        do {
            try context.save()
        }
        catch let error {
            XCTFail("Unable to save author with nested books, error was: \(error)")
        }
        
        do {
            let result = try context.fetch(Book.fetchRequest()) as! [Book]
            XCTAssertEqual(result.count, author.books!.count)
            XCTAssertEqual(result.first!.author, author)
        }
        catch let error {
            XCTFail("Unable to fetch previously saved author, error was: \(error)")
        }
    }
    
    func testFaultedObjects() {
        let author = Author(dictionary: authorAndBooksInfo, context: context)
        XCTAssertTrue(author.objectID.isTemporaryID)
        XCTAssertFalse(author.isFault)
        try! context.save()
        
        // Fetched objects are initially faults, unless the fetch request specifies otherwise.
        context.reset()
        let fetchedAuthor = try! context.fetch(Author.fetchRequest()).first! as! Author
        XCTAssertTrue(fetchedAuthor.isFault)
        XCTAssertTrue(fetchedAuthor.hasFault(forRelationshipNamed: Author.booksKey))
        XCTAssertFalse(fetchedAuthor.objectID.isTemporaryID)
        
        // Accessing the author's `books` property trips the fault. Note, however,
        // that objects in the set of books are themselves faults.
        let fetchedBooks = fetchedAuthor.books!
        let book1 = fetchedBooks.firstObject as! Book
        XCTAssertTrue(book1.isFault)
        XCTAssertFalse(fetchedAuthor.isFault)
        XCTAssertFalse(fetchedAuthor.hasFault(forRelationshipNamed: Author.booksKey))
        
        // Accessing the book's `title` property trips the fault that represents the book.
        XCTAssertEqual(book1.title, "Book 1")
        XCTAssertFalse(book1.isFault)
        
        // A fetched object's managed object id contains references to the object's
        // Core Data entity, as well as a URI that includes the store identifier,
        // entity name, and primary key
        XCTAssertEqual(fetchedAuthor.objectID.entity.name, "Author")
        XCTAssertEqual(fetchedAuthor.objectID.uriRepresentation().host,
                       fetchedAuthor.objectID.persistentStore?.identifier)
    }
}

