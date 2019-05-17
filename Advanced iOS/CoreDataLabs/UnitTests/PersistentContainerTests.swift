// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest
import CoreData
@testable import EbooksModel

class PersistentContainerTests: XCTestCase
{
    let modelName = "Ebooks"
    let storeName = "EbooksTest"
    var container: NSPersistentContainer!
    var model: NSManagedObjectModel!
    
    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: ModelController.self)
        model = NSManagedObjectModel.mergedModel(from: [bundle])!
        container = NSPersistentContainer(name: storeName, managedObjectModel: model)
        container.loadPersistentStores { store, error in
            print(error ?? "Persistent store loaded:\n\(store)")
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDirectoryURL() {
        let dirName = NSPersistentContainer.defaultDirectoryURL().lastPathComponent
        XCTAssertEqual(dirName, "Application Support")
    }
    
    func testStoreNameAndType() {
        let storeCoordinator = container.persistentStoreCoordinator
        let store = storeCoordinator.persistentStores.first!
        let name = store.url!.deletingPathExtension().lastPathComponent
        XCTAssertEqual(name, storeName)
        XCTAssertEqual(store.type, "SQLite")
    }
    
    func testModel() {
        let model = container.persistentStoreCoordinator.managedObjectModel
        XCTAssertEqual(model, self.model)
    }
    
    func testContext() {
        XCTAssertEqual(container.viewContext.concurrencyType,
                       NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    }
}
