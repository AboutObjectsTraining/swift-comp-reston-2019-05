// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.
import os
import CoreData
import UIKit
import eBooksModel

///
/// An abstract base class for table view and collection view data sources.
///
@objcMembers
open class DataSource: NSObject
{
    struct Defaults {
        static let modelName = "eBooks"
        static let storeType = "sqlite"
        static let batchSize = 20 // TODO: make this user configurable, and provide default value in AppDefaults.plist
    }
    
    // TODO: Should this be a stored property (e.g., for unit testing)?
    
    /// Returns the name of the persistent container. Can be overridden by subclasses to provide a different name.
    open class var persistentContainerName: String { return Defaults.modelName }
    
    open class var modelName: String { return Defaults.modelName }
    open class var storeName: String { return Defaults.modelName }
    open class var storeUrl: URL? { return URL.documentUrl(for: storeName, type: Defaults.storeType) }
    open class var modelUrl: URL? { return Bundle(for: ManagedObject.self).url(forResource: modelName, withExtension: "momd") }
    open class var mergePolicy: NSMergePolicy? { return NSMergePolicy.mergeByPropertyObjectTrump }
    
    /// Either a `UITableView` or `UICollectionView` managed by this data source.
    @IBOutlet public weak var targetView: UIView!
    
    var tableView: UITableView? { return targetView as? UITableView }
    var collectionView: UICollectionView? { return targetView as? UICollectionView }
    
    open class var model: NSManagedObjectModel {
        guard let mom = NSManagedObjectModel(contentsOf: modelUrl!) else { fatalError("Unable to load model \(modelName)") }
        return mom
    }
    
    static var mom = model
    
    open lazy var managedObjectModel: NSManagedObjectModel = {
        return type(of: self).mom
    }()
    
    open private(set) lazy var context: NSManagedObjectContext = configureManagedObjectContext()
    /// May be overridden by subclasses to return a different context.
    open func configureManagedObjectContext() -> NSManagedObjectContext {
        container.viewContext.mergePolicy = DataSource.mergePolicy as Any
        return container.viewContext
    }
    
    open private(set) lazy var fetchedResultsController: NSFetchedResultsController = configureFetchedResultsController()
    /// Returns a `NSFetchedResultsController` initialized with values from the `fetchRequest`, `managedObjectContext`,
    /// `sectionNameKeyPath`, and `cacheName` properties, and with its `delegate` property set to `self`.
    /// May be overridden by subclasses, but its generally easier to overide the properties that provide the configuration values.
    open func configureFetchedResultsController() -> NSFetchedResultsController<ManagedObject> {
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: sectionNameKeyPath,
                                                    cacheName: cacheName)
        controller.delegate = self
        return controller
    }
    
    open private(set) lazy var container: NSPersistentContainer = NSPersistentContainer(name: Defaults.modelName, managedObjectModel: managedObjectModel)
    
    @discardableResult
    open func addPersistentStore(coordinator: NSPersistentStoreCoordinator) -> NSPersistentStore? {
        os_log("Store is %@", type(of: self).storeUrl?.description ?? "null")
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        do { return try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: type(of: self).storeUrl, options: options) }
        catch { os_log("Unable to add SQLite store due to %@", error.localizedDescription) }
        return nil
    }
    
    public override init() {
        super.init()
        addPersistentStore(coordinator: container.persistentStoreCoordinator)
    }
}

// MARK: - Configuration
extension DataSource
{
    /// Must be overridden by subclasses to return the name of the entity to be fetched.
    open var entityName: String { fatalError("Subclasses must override this property to return an entity name.") }
    
    /// May be overridden by subclasses to provide a sort ordering
    open var sortDescriptors: [NSSortDescriptor]? { return nil }
    /// May be overridden by subclasses to provide a cache file name. Default is `nil`.
    open var cacheName: String? { return nil }
    /// May be overridden by subclasses to provide a key path for ordering results by section. Default is `nil`
    open var sectionNameKeyPath: String? { return nil }
    /// May be overridden by subclasses to provide an NSPredicate object. Default is `nil`.
    open var predicate: NSPredicate? { return nil }
    
    /// Returns a fetch request initialized with values from the `sortDescriptors` and `predicate` properties,
    /// with a default batch size of `Defaults.batchSize`. May be overridden by subclasses to provide a custom fetch request.
    open var fetchRequest: NSFetchRequest<ManagedObject> {
        let request = NSFetchRequest<ManagedObject>(entityName: entityName)
        request.sortDescriptors = sortDescriptors
        request.fetchBatchSize = Defaults.batchSize
        request.predicate = predicate
        return request
    }
}

// MARK: - Storing and retrieving managed objects
extension DataSource
{
    open func object(at indexPath: IndexPath) -> ManagedObject? {
        return fetchedResultsController.object(at: indexPath)
    }
    
    open func book(at indexPath: IndexPath) -> Book {
        guard let book = object(at: indexPath) as? Book else { fatalError("Invalid index path \(indexPath)") }
        return book
    }
    
    open func fetch() throws {
        try fetchedResultsController.performFetch()
    }
    
    // TODO: Configure fetch request in MOM
    func authorFetchRequest(authorId: NSNumber) -> NSFetchRequest<Author> {
        let fetchRequest = NSFetchRequest<Author>(entityName: Author.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Author.Keys.authorId, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "authorId = %@", authorId)
        return fetchRequest
    }
    func bookFetchRequest(bookId: NSNumber) -> NSFetchRequest<Book> {
        let fetchRequest = NSFetchRequest<Book>(entityName: Book.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Book.Keys.bookId, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "bookId = %@", bookId)
        return fetchRequest
    }
    
    public func fetchAuthor(authorId: NSNumber, in context: NSManagedObjectContext) -> Author? {
        do {
            let authors = try context.fetch(authorFetchRequest(authorId: authorId))
            if authors.count > 1 { os_log("WARNING: Duplicate authors with id %@", authorId) }
            return authors.first
        }
        catch let e as NSError {
            os_log("Unable to fetch with request %@. Error was %@ %@", fetchRequest, e.localizedDescription, e.localizedFailureReason ?? "")
        }
        return nil
    }
    public func fetchBook(bookId: NSNumber, in context: NSManagedObjectContext) -> Book? {
        do {
            let books = try context.fetch(bookFetchRequest(bookId: bookId))
            if books.count > 1 { os_log("WARNING: Duplicate books with id %@", bookId) }
            return books.first
        }
        catch let e as NSError {
            os_log("Unable to fetch with request %@. Error was %@ %@", fetchRequest, e.localizedDescription, e.localizedFailureReason ?? "")
        }
        return nil
    }
    
    open func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                os_log("Failed to save with error: %@", error.localizedDescription)
                print(error)
            }
        }
    }
}

// MARK: - Cloning
extension DataSource
{
    open func insertCopy(book: Book) throws {
        guard let originalAuthor = book.author else { return }
        var matchingAuthor: Author?
        for obj in context.registeredObjects {
            if obj.objectID == originalAuthor.objectID {
                matchingAuthor = obj as? Author
                break
            }
        }
        
        let author = matchingAuthor == nil ? originalAuthor.shallowCloned(insertInto: context) as? Author : matchingAuthor!
        guard let clonedBook = book.shallowCloned(insertInto: context) as? Book else {
            throw NSError(domain: "eBooks", code: 100,
                          userInfo: [NSLocalizedFailureErrorKey: "Unable to clone book \(book)"])
        }
        clonedBook.author = author
    }
    
    // TODO: Move to unit test
    func insertCopy(author: Author, in context: NSManagedObjectContext) throws {
        let fetchedAuthor = fetchAuthor(authorId: author.authorId, in: context)
        if fetchedAuthor != nil { return }
        let _ = author.shallowCloned(insertInto: context)
    }
}

// MARK: - Working with table views
extension DataSource
{
    /**
     * Overridden by subclasses to return a reuse identifier for the cell prototype
     * that corresponds to `indexPath`.
     * @param indexPath The index path for the current row.
     */
    open func reuseIdentifier(for cellAt: IndexPath) -> String {
        return "Cell"
    }
    
    open func reloadData() {
        if targetView is UITableView {
            tableView?.reloadData()
        } else { collectionView?.reloadData() }
    }
    
    open func invalidateObjects() {
        context.reset()
        try? fetchedResultsController.performFetch()
        reloadData()
    }
    
    @objc open func populate(cell: UITableViewCell, at indexPath: IndexPath) { }
    @objc open func configure(cell: UITableViewCell, at indexPath: IndexPath) { }
    
    // FIXME: non-overridable
    @nonobjc open func populate(cell: UICollectionViewCell, at indexPath: IndexPath) { }
    @nonobjc open func configure(cell: UICollectionViewCell, at indexPath: IndexPath) { }
}

extension DataSource: UITableViewDataSource
{
    public func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let info = fetchedResultsController.sections?[section]
        return info?.numberOfObjects ?? 0
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier(for: indexPath), for: indexPath)
        populate(cell: cell, at: indexPath)
        configure(cell: cell, at: indexPath)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let object = fetchedResultsController.object(at: indexPath)
        fetchedResultsController.managedObjectContext.delete(object)
    }
}

extension DataSource: UICollectionViewDataSource
{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier(for: indexPath), for: indexPath)
        populate(cell: cell, at: indexPath)
        configure(cell: cell, at: indexPath)
        return cell
    }
}

extension DataSource: NSFetchedResultsControllerDelegate
{
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                           didChange sectionInfo: NSFetchedResultsSectionInfo,
                           atSectionIndex sectionIndex: Int,
                           for type: NSFetchedResultsChangeType)
    {
        switch type {
        case .insert: tableView?.insertSections([sectionIndex], with: .automatic)
        case .delete: tableView?.deleteSections([sectionIndex], with: .automatic)
        default: break
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                           didChange anObject: Any,
                           at indexPath: IndexPath?,
                           for type: NSFetchedResultsChangeType,
                           newIndexPath: IndexPath?)
    {
        guard let indexPath = indexPath, let tableView = tableView else { return }
        switch type {
        case .insert: tableView.insertRows(at: [indexPath], with: .automatic)
        case .delete: tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            if let cell = tableView.cellForRow(at: indexPath) {
                populate(cell: cell, at: indexPath)
            }
        case .move:
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
}
