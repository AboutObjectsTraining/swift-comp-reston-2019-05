// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
import os
import Foundation
import CoreData
import eBooksModel

class SearchResultsDataSource: DataSource
{
    @IBOutlet weak var searchService: SearchService!
    
    override var entityName: String { return Book.entityName }
    override var sectionNameKeyPath: String? { return "author.name" }
    override var sortDescriptors: [NSSortDescriptor]? { return [NSSortDescriptor(key: "title", ascending: true)] }
    
    // TODO: Can we use the container's store coordinator instead?
    private lazy var storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: container.managedObjectModel)
    
    private var operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = UserDefaults.searchConcurrentOperationsCount
        return operationQueue
    }()
    
    override open func addPersistentStore(coordinator: NSPersistentStoreCoordinator) -> NSPersistentStore? {
        do { return try storeCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: [:]) }
        catch { os_log("Unable to add in-memory store due to %@", error.localizedDescription) }
        return nil
    }
    
    override open func configureManagedObjectContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = storeCoordinator
        context.name = "In-memory Context"
        return context
    }
}

extension SearchResultsDataSource
{
    override func reuseIdentifier(for cellAt: IndexPath) -> String {
        return "iTunesBookSummary"
    }
    
    func insertManagedObjects(jsonDictionary: JsonDictionary) {
        invalidateObjects()
        let authorsJson = JsonNormalization.authorsJson(jsonDictionary: jsonDictionary)
        for authorJson in authorsJson {
            let author = Author(context: context)
            author.decode(from: authorJson)
        }
        //        print(context.registeredObjects)
    }
    
    override func populate(cell: UITableViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? SearchResultsCell else {
            fatalError("Unable to downcast cell as \(SearchResultsCell.self)")
        }
        guard let book = fetchedResultsController.object(at: indexPath) as? Book else {
            fatalError("Unable to downcast object at \(indexPath) as \(Book.self)")
        }
        cell.titleLabel.text = book.title
        cell.yearLabel.text = DateFormatter(withStyle: .short).string(from: book.releaseDate as? Date ?? Date())
        cell.authorLabel.text = book.author?.name
        cell.libraryIcon.isHidden = !book.isInLibrary
        
        if let thumbnailImage = book.thumbnailImage as? UIImage {
            cell.thumbnailImageView.image = thumbnailImage
        }
        else {
            searchService.fetchThumbnailImage(for: book)
        }
    }
}
