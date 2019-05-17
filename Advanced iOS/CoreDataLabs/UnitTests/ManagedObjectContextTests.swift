// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest
import CoreData
@testable import EbooksModel

class ManagedObjectsContextTests: XCTestCase
{
    var container: NSPersistentContainer!
    lazy var model: NSManagedObjectModel! =
        NSManagedObjectModel.mergedModel(from: [Bundle(for: Book.self)])

    override func setUp() {
        super.setUp()
        container = NSPersistentContainer(name: storeName,
                                          managedObjectModel: model)
        // Load one or more NSPersistentStore objects. We'll cover this in more detail later.
        container.loadPersistentStores { store, error in
            print(error ?? "Persistent store loaded:\n\(store)")
        }
        print("\(NSPersistentContainer.defaultDirectoryURL())\n")
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
    
    func testCreateContainer() {
        let container = NSPersistentContainer(name: storeName,
                                              managedObjectModel: model)
        // Load one or more NSPersistentStore objects.
        // (We'll cover this in more detail shortly.)
        container.loadPersistentStores { store, error in
            print(error ?? "Persistent store loaded:\n\(store)")
        }
        
        
    }
    
    func testInsertManagedObject() {
        XCTAssertEqual(container.viewContext.insertedObjects.count, 0)
        XCTAssertEqual(container.viewContext.registeredObjects.count, 0)
        let entity = model.entitiesByName["Book"]!
        let mo = NSManagedObject(entity: entity, insertInto: nil)
        XCTAssertTrue(mo is Book)
        container.viewContext.insert(mo)
        print(mo)
        XCTAssertEqual(container.viewContext.registeredObjects.count, 1)
        XCTAssertEqual(container.viewContext.insertedObjects.count, 1)
    }
    
    func testSaveBook() {
        let book = Book(context: container.viewContext)
        book.title = "A Title"
        
        do {
            try container.viewContext.save()
        }
        catch let error {
            XCTFail("Unable to save book. Error was \(error)")
        }
    }
    
    func testValidateBookForSave() {
        let book = Book(context: container.viewContext)
        
        do {
            try book.validateForUpdate()
            XCTFail("Should have failed validation because title not optional, and min length must be >= 1")
        }
        catch {
            print("Book not valid for update because title was not set")
        }
        
        do {
            try container.viewContext.save()
            XCTFail("Should have failed validation because title not optional, and min length must be >= 1")
        }
        catch {
            print("Book could not be saved because title was not set")
        }
    }
}

