// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest
import CoreData
@testable import EbooksModel

class ManagedObjectsPropertiesTests: XCTest
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
        print()
    }
    
    override func tearDown() {
        print()
        super.tearDown()
    }
    
    func testMOPrimitiveValues() {
        let mo = NSManagedObject(context: container.viewContext)
        // mo.title = "A"
        mo.setPrimitiveValue("A", forKey: "title")
        XCTAssertEqual(mo.primitiveValue(forKey: "title") as! String, "A")
    }
    
    func testMORespondsTo() {
        let mo = NSManagedObject(context: container.viewContext)
        // XCTAssertTrue(mo.responds(to: #selector(title)))
        XCTAssertTrue(mo.responds(to:NSSelectorFromString("title")))
    }
    
    func testBookPrimitiveValues() {
        let book = Book(context: container.viewContext)
        book.title = "A"
        book.setPrimitiveValue("B", forKey: "title")
        XCTAssertEqual(book.title, "B")
    }
}
