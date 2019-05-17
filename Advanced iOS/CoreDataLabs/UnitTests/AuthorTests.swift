// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest
import CoreData
@testable import EbooksModel

let iTunesId = 456

private var managedObjectModel: NSManagedObjectModel = {
    let bundle = Bundle(for: Book.self)
    return NSManagedObjectModel.mergedModel(from: [bundle])!
}()

class AuthorTests: XCTestCase
{
    var container: NSPersistentContainer!
    
    var context: NSManagedObjectContext { return container.viewContext }
    
    override func setUp() {
        super.setUp()
        container = NSPersistentContainer(name: storeName, managedObjectModel: managedObjectModel)
        container.loadPersistentStores { store, error in print(error ?? "Persistent store loaded:\n\(store)") }
        print("\n\(NSPersistentContainer.defaultDirectoryURL())\n")
        print("\(FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask))\n")
    }
    
    override func tearDown() {
        if let dbUrl = container.persistentStoreDescriptions.first?.url, FileManager.default.fileExists(atPath: dbUrl.path) {
            try! container.persistentStoreCoordinator.destroyPersistentStore(at: dbUrl, ofType: "sqlite", options: nil)
        }
        print()
        super.tearDown()
    }
}

// MARK: Inserting and Deleting in Context
extension AuthorTests
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

// MARK: Primitive Values
extension AuthorTests
{
    func testPrimitivePropertyValues() {
        let author = Author(context: context)
        XCTAssertEqual(author.name, nil)
        XCTAssertEqual(author.primitiveValue(forKey: "name") as? String, nil)
        
        let name = "A"
        author.setPrimitiveValue(name, forKey: "name")
        XCTAssertEqual(author.name, name)
        XCTAssertEqual(author.primitiveValue(forKey: "name") as? String, name)
    }
}

// MARK: Saving and Fetching
extension AuthorTests
{
    var authoriTunesIdFetchRequest: NSFetchRequest<Author> {
        let fetchRequest: NSFetchRequest<Author> = Author.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %i", "iTunesId", iTunesId)
        return fetchRequest
    }
    
    func testSaveAuthor() {
        let author = Author(context: context)
        print("author is inserted: \(author.isInserted)")
        print("\nRegistered objects:\n\(context.registeredObjects)")
        
        author.iTunesId = 123
        author.name = "C"
        author.rating = 2
        
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

        context.reset()
        XCTAssertNotEqual(temporaryId, persistentId)
        XCTAssertEqual(context.registeredObjects.count, 0)
        XCTAssertEqual(try! context.count(for: Author.fetchRequest()), 1)
    }
    
    func testSaveAuthorWithNoNameFailsValidation() {
        let author = Author(context: context)
        print("author is inserted: \(author.isInserted)")
        print("\nRegistered objects:\n\(context.registeredObjects)")

        if author.hasPersistentChangedValues {
            do {
                try context.save()
                XCTFail("Save should fail when author's name is less than one character long")
            }
            catch let error {
                print(error)
            }
        }
        
        context.reset()
        XCTAssertEqual(try! context.count(for: authoriTunesIdFetchRequest), 0)
    }

    func testSaveAuthors() {
        let author1 = Author(dictionary: ["iTunesId": 234, "name": "D", "rating": 2], context: context)
        print("author1 is inserted: \(author1.isInserted)")
        
        let author2 = Author(dictionary: ["iTunesId": 345, "name": "E", "rating": 3], context: context)
        print("author2 is inserted: \(author2.isInserted)")
        print("\nRegistered objects:\n\(context.registeredObjects)")
        
        do {
            try context.save()
        }
        catch let error {
            XCTFail("Unable to save authors, error was: \(error)")
        }
        
        context.reset()
        XCTAssertEqual(context.registeredObjects.count, 0)
        XCTAssertEqual(try! context.count(for: Author.fetchRequest()), 2)
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
            let result = try context.fetch(authoriTunesIdFetchRequest)
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

// MARK: Background Tasks
extension AuthorTests
{
    func testAsynchSaveAuthor() {
        let iTunesId = 456
        let saveExpectation = expectation(description: "Author was saved")
        container.performBackgroundTask { ctx in
            let author = Author(dictionary: ["iTunesId": iTunesId, "name": "G", "rating": 3], context: ctx)
            do {
                try ctx.save()
                saveExpectation.fulfill()
                print("Saved author: \(author)")
            }
            catch let error {
                XCTFail("Unable to save author, error was: \(error)")
            }
        }
        
        waitForExpectations(timeout: 0.1) { _ in
            do {
                let result = try self.context.fetch(self.authoriTunesIdFetchRequest)
                XCTAssertEqual(result.first!.iTunesId, Int32(iTunesId))
            }
            catch let error {
                XCTFail("Unable to fetch previously saved author, error was: \(error)")
            }
        }
    }
}


// MARK: Nested Books
extension AuthorTests
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
