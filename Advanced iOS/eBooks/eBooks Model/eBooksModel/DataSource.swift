// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.
import os
import CoreData
import UIKit

///
/// An abstract base class for table view and collection view data sources.
///
@objcMembers
@objc(EBMDataSource)
open class DataSource: NSObject
{
    struct Defaults {
        static let modelName = "eBooks"
        static let batchSize = 20 // TODO: make this user configurable, and provide default value in AppDefaults.plist
    }
    
    // TODO: Should this be a stored property (e.g., for unit testing)?
    
    /// Returns the name of the persistent container. Can be overridden by subclasses to provide a different name.
    open var persistentContainerName: String { return Defaults.modelName }
    
    /// Either a `UITableView` or `UICollectionView` managed by this data source.
    public weak var targetView: UIView!
    
    var tableView: UITableView? { return targetView as? UITableView }
    var collectionView: UICollectionView? { return targetView as? UICollectionView }
    
    open lazy var modelUrl = Bundle(for: DataSource.self).url(forResource: Defaults.modelName, withExtension: "momd")
    open lazy var managedObjectModel: NSManagedObjectModel = {
        guard let mom = NSManagedObjectModel(contentsOf: modelUrl!) else { fatalError("Unable to load model \(Defaults.modelName)") }
        return mom
    }()
    
    open lazy var persistentContainer: NSPersistentContainer =  NSPersistentContainer(name: Defaults.modelName, managedObjectModel: managedObjectModel)
    public var persistentStoreCoordinator: NSPersistentStoreCoordinator { return persistentContainer.persistentStoreCoordinator}
    
    open private(set) lazy var managedObjectContext: NSManagedObjectContext = configureManagedObjectContext()
    open private(set) lazy var fetchedResultsController: NSFetchedResultsController = configureFetchedResultsController()
}

// MARK: - Configuring the fetched results controller
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
    
    /// Returns a `NSFetchedResultsController` initialized with values from the `fetchRequest`, `managedObjectContext`,
    /// `sectionNameKeyPath`, and `cacheName` properties, and with its `delegate` property set to `self`.
    /// May be overridden by subclasses, but its generally easier to overide the properties that provide the configuration values.
    open func configureFetchedResultsController() -> NSFetchedResultsController<ManagedObject> {
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: managedObjectContext,
                                                    sectionNameKeyPath: sectionNameKeyPath,
                                                    cacheName: cacheName)
        controller.delegate = self
        return controller
    }
    
    /// May be overridden by subclasses to return a different context.
    open func configureManagedObjectContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

// MARK: - Storing and retrieving managed objects
extension DataSource
{
    open func object(at indexPath: IndexPath) -> ManagedObject? {
        return fetchedResultsController.object(at: indexPath)
    }
    
    open func fetch() throws {
        try fetchedResultsController.performFetch()
    }
    
    open func save() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                os_log("Failed to save with error: %@", error.localizedDescription)
            }
        }
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
        managedObjectContext.reset()
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
