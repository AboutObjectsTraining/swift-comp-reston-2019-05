// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest
import CoreData
@testable import EbooksModel

class ManagedObjectModelTests: XCTestCase
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
    
    func testPersistentContainer() {
        print(model)
        XCTAssertNotNil(model)
    }
    
    func testManagedObjectModel() {
        let entities = model.entities
        print(entities)
        XCTAssertNotNil(entities)
    }
    
    func testEntityDescriptions() {
        for entity in model.entities {
            print("""
                Entity: \(entity.name ?? "nil")
                -----------------------
                \tClass name: \(entity.managedObjectClassName ?? "nil")
                \tAttributes
                """)
            for (key, attribute) in entity.attributesByName {
                print("\t\t\(key): \(attribute.attributeValueClassName ?? "nil")")
            }
            print("\tRelationships")
            for (key, relationship) in entity.relationshipsByName {
                print("\t\t\(key): \(relationship.destinationEntity?.name ?? "nil")")
            }
            print()
        }
    }
    
    func testAttributes() {
        let entities = model.entities
        print("""
            
            Attributes for entity \(entities[0].name!)
            ****************************
            
            \(entities[0].attributesByName)
            """)
        print("""
            
            Attributes for entity \(entities[1].name!)
            ***************************
            
            \(entities[1].attributesByName)
            """)
    }

    func testRelationships() {
        let entities = model.entities
        print("""
            
            Relationships for entity \(entities[0].name!)
            *******************************
            
            \(entities[0].relationshipsByName)
            """)
        print("""
            
            Relationships for entity \(entities[1].name!)
            ******************************
            
            \(entities[1].relationshipsByName)
            """)
    }
}
