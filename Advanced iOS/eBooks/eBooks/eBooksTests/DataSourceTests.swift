// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import os
import XCTest
import CoreData
@testable import eBooks
@testable import eBooksModel

let iTunesSampleJson: JsonDictionary = {
    let url = Bundle(for: DataSourceTests.self).url(forResource: "iTunesSample", withExtension: "json")
    let data = try! Data(contentsOf: url!)
    let json = try! JSONSerialization.jsonObject(with: data, options: [])
    return json as! JsonDictionary
}()

let iTunesAuthorsJson = JsonNormalization.authorsJson(jsonDictionary: iTunesSampleJson)

private var model: NSManagedObjectModel! =
    NSManagedObjectModel.mergedModel(from: [Bundle(for: ManagedObject.self)])

class DataSourceTests: XCTestCase
{
    static let transformersRegistered: Bool = {
        registerValueTransformers()
        return true
    }()
    class func registerValueTransformers() {
        ValueTransformer.setValueTransformer(UrlTransformer(),   forName: UrlTransformer.transformerName)
        ValueTransformer.setValueTransformer(UuidTransformer(),  forName: UuidTransformer.transformerName)
        ValueTransformer.setValueTransformer(ImageTransformer(), forName: ImageTransformer.transformerName)
        ValueTransformer.setValueTransformer(DateTransformer(),  forName: DateTransformer.transformerName)
    }
    
    static var model: NSManagedObjectModel!
    var dataSource: DataSource = {
        let ds = DataSource()
        if DataSourceTests.model == nil { DataSourceTests.model = ds.container.managedObjectModel }
        return ds
    }()

    lazy var inMemoryStoreCoordinator: NSPersistentStoreCoordinator = {
        let psc = NSPersistentStoreCoordinator(managedObjectModel: DataSourceTests.model)
        do { try psc.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: [:]) }
        catch { os_log("Unable to add in-memory store due to %@", error.localizedDescription) }
        return psc
    }()
    
    lazy var inMemoryContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = inMemoryStoreCoordinator
        return context
    }()
    
    override func setUp() {
        super.setUp()
        let _ = DataSourceTests.transformersRegistered
        dataSource.container.loadPersistentStores { _, error in
            if let error = error { XCTFail("Unable to load store; error was \(error)") }
        }
    }
    
    override func tearDown() {
        dataSource.context.reset()
        inMemoryContext.reset()
        let store = dataSource.container.persistentStoreCoordinator.persistentStores.first!
        try? dataSource.container.persistentStoreCoordinator.remove(store)
        
        if let url = dataSource.container.persistentStoreDescriptions.first?.url, FileManager.default.fileExists(atPath: url.path) {
            print("destroying store at url \(url)")
            try! dataSource.container.persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: "sqlite", options: nil)
        }
        print()
        super.tearDown()
    }

    func testCloneBookWithNewAuthor() {
        var authors: [Author] = []
        for authorJson in iTunesAuthorsJson {
            let author = Author(context: inMemoryContext)
            author.decode(from: authorJson)
            authors.append(author)
        }
        
        let bookToSave: Book! = authors.first?.books.array[0] as? Book
        try! dataSource.insertCopy(book: bookToSave)
//        try! dataSource.insertCopy(book: bookToSave, in: dataSource.context)

        do { try dataSource.context.save() }
        catch { os_log("Save failed. %@", (error as NSError).localizedDescription) }
        
        let fetchRequest = NSFetchRequest<Author>(entityName: Author.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Author.Keys.name, ascending: true)]
        
        var fetchedObjs: [Author]?
        do {
            fetchedObjs = try dataSource.context.fetch(fetchRequest)
        } catch {
            print(error)
            XCTFail("Unable to save")
        }
        
        os_log("Fetched authors:\n%@", fetchedObjs!)
        let fetchedBook = fetchedObjs?.first?.books.firstObject! as? Book
        XCTAssertEqual(bookToSave.bookId, fetchedBook?.bookId)
    }

    func testCloneBookWithExistingAuthor() {
        var authors: [Author] = []
        for authorJson in iTunesAuthorsJson {
            let author = Author(context: inMemoryContext)
            author.decode(from: authorJson)
            authors.append(author)
        }
        
        let bookToSave: Book! = authors.first?.books.array[0] as? Book
        let authorToSave: Author! = authors.first!
        
        try! dataSource.insertCopy(author: authorToSave, in: dataSource.context)
        try! dataSource.context.save()
        
        try! dataSource.insertCopy(book: bookToSave, in: dataSource.context)
        try! dataSource.context.save()
        
        let fetchRequest = NSFetchRequest<Author>(entityName: Author.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Author.Keys.name, ascending: true)]
        
        var fetchedObjs: [Author]?
        do {
            fetchedObjs = try dataSource.context.fetch(fetchRequest)
        } catch {
            print(error)
            XCTFail("Unable to save")
        }
        
        os_log("Fetched authors:\n%@", fetchedObjs!)
        let fetchedBook = fetchedObjs?.first?.books.firstObject! as? Book
        XCTAssertEqual(bookToSave.bookId, fetchedBook?.bookId)
    }
}
