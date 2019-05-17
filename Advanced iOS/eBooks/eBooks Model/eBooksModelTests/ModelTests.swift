// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import os
import XCTest
import CoreData
@testable import eBooksModel

let iTunesSampleJson: JsonDictionary = {
    let url = Bundle(for: JsonTransformationTests.self).url(forResource: "iTunesSample", withExtension: "json")
    let data = try! Data(contentsOf: url!)
    let json = try! JSONSerialization.jsonObject(with: data, options: [])
    return json as! JsonDictionary
}()

let iTunesAuthorsJson = JsonNormalization.authorsJson(jsonDictionary: iTunesSampleJson)

struct JsonKeys {
    static let authorId = "artistId"
    static let name = "artistName"
    static let books = "books"
    static let bookId = "trackId"
    static let title = "trackName"
}

struct Author1 {
    static let id = 123
    static let name = "Fred Smith"
}
struct Book1 {
    static let id = 987
    static let title = "My First Book"
}
struct Book2 {
    static let id = 876
    static let title = "Book Deux"
}
struct Genre1 {
    static let id = "101"
    static let name = "Computers"
}
struct Genre2 {
    static let id = "102"
    static let name = "Mobile Devices"
}

let bookInfo1: [String: Any] = [JsonKeys.bookId: Book1.id,
                                JsonKeys.title: Book1.title]
let bookInfo2: [String: Any] = [JsonKeys.bookId: Book2.id,
                                JsonKeys.title: Book2.title]
let authorInfo1: [String: Any] = [JsonKeys.authorId: Author1.id,
                                  JsonKeys.name: Author1.name,
                                  JsonKeys.books: [bookInfo1, bookInfo2]]

let genreInfo1: [String: Any] = [Genre.Keys.genreId: Genre1.id,
                                 Genre.Keys.name: Genre1.name]
let genreInfo2: [String: Any] = [Genre.Keys.genreId: Genre2.id,
                                 Genre.Keys.name: Genre2.name]
let bookWithNestedGenresInfo1: [String: Any] = [JsonKeys.bookId: Book1.id,
                                                JsonKeys.title: Book1.title,
                                                Book.Keys.genres: [genreInfo1, genreInfo2]]

class ModelTests: XCTestCase
{
    let modelName = "eBooks"
    var container: NSPersistentContainer!
    lazy var model: NSManagedObjectModel! = NSManagedObjectModel.mergedModel(from: [Bundle(for: ManagedObject.self)])
    
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
    
    override func setUp() {
        super.setUp()
        let _ = ModelTests.transformersRegistered
        container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        container.loadPersistentStores { store, error in print(error ?? "Persistent store loaded:\n\(store)") }
        print("\(NSPersistentContainer.defaultDirectoryURL())\n")
    }
    override func tearDown() {
        if let url = container.persistentStoreDescriptions.first?.url, FileManager.default.fileExists(atPath: url.path) {
            try! container.persistentStoreCoordinator.destroyPersistentStore(at: url, ofType: "sqlite", options: nil)
        }
        print()
        super.tearDown()
    }
    
    func testDecodeBook() {
        let book = Book(context: container.viewContext)
        print(book)
        book.decode(from: bookInfo1)
        print(book)
    }
    
    func testDecodeAuthor() {
        let author = Author(context: container.viewContext)
        print(author)
        author.decode(from: authorInfo1)
        print(author)
    }
    
    func testSaveDecodedBook() {
        let book = Book(context: container.viewContext)
        book.decode(from: bookInfo1)
        
        os_log("Saving object:\n%@", book)
        try! container.viewContext.save()

        let fetchedObjs = try! container.viewContext.fetch(Book.fetchRequest)
        os_log("Fetched object:\n%@", fetchedObjs.first!)
        
        XCTAssertEqual(fetchedObjs.count, 1)
        XCTAssertEqual(book.objectID, fetchedObjs.first!.objectID)
    }

    func testSaveDecodedBookWithNestedGenres() {
        let book = Book(context: container.viewContext)
        book.decode(from: bookWithNestedGenresInfo1)
        
        os_log("Saving object:\n%@", book)
        do {
            try container.viewContext.save()
        } catch {
            print(error)
            XCTFail("Unable to save")
        }

        let fetchedObjs = try! container.viewContext.fetch(Book.fetchRequest)
        os_log("Fetched object:\n%@", fetchedObjs.first!)
        
        XCTAssertEqual(fetchedObjs.count, 1)
        XCTAssertEqual(book.objectID, fetchedObjs.first!.objectID)
    }

    func testSaveDecoded_iTunesJson() {
        for authorJson in iTunesAuthorsJson {
            let author = Author(context: container.viewContext)
            author.decode(from: authorJson)
        }
        
        do {
            try container.viewContext.save()
        } catch {
            print(error)
            XCTFail("Unable to save")
        }

        let fetchRequest = NSFetchRequest<Author>(entityName: Author.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Author.Keys.name, ascending: true)]
        
        var fetchedObjs: [Author]?
        do {
            fetchedObjs = try container.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
            XCTFail("Unable to save")
        }

        os_log("Fetched objects:\n%@", fetchedObjs!)
        XCTAssertEqual(fetchedObjs!.count, 2)
        
        let author1 = fetchedObjs![1]
        XCTAssertEqual(author1.books.count, 2)
        
        let book = fetchedObjs![0].books[0] as! Book
        os_log("Fetched book:\n%@", book)
        
        let fetchedGenres = try! container.viewContext.fetch(Genre.fetchRequest)
        os_log("Genres:\n%@", fetchedGenres)
    }
}
