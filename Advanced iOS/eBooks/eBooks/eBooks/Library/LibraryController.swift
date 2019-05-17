// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
import os
import UIKit
import eBooksModel

@objcMembers
class LibraryController: UITableViewController {
    
    @IBOutlet var dataSource: LibraryDataSource!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(addBookToLibrary(notification:)),
            name: NSNotification.Name.userDidSelectAddBookToLibrary,
            object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        try? dataSource.fetch()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if !editing { dataSource.save() }
        super.setEditing(editing, animated: animated)
    }
    
    func addBookToLibrary(notification: NSNotification) {
        guard let book = notification.userInfo?["book"] as? Book else {
            os_log(.error, "Unable to obtain a book from %@", String(describing: notification.userInfo))
            return
        }
        
        do {
            try dataSource.insertCopy(book: book)
        } catch {
            os_log(.error, "Unable to insert book %@; error was %@", book, error.localizedDescription)
        }
        
        dataSource.save()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "View":
            guard let viewBookController = segue.destination as? ViewBookController else {
                fatalError("Unexpected controller type \(type(of: segue.destination))")
            }
            if let indexPath = tableView.indexPathForSelectedRow, let book = dataSource.object(at: indexPath) as? Book {
                viewBookController.book = book
            }
        default: fatalError("Unexpected segue \(segue)")
        }
    }
}

// MARK: - Actions
extension LibraryController {
    @IBAction func cancelAddingBook(segue: UIStoryboardSegue) { }
}
