//
//  SearchResultsController.swift
//  Readings
//
//  Created by About Objects on 1/21/19.
//  Copyright © 2019 About Objects. All rights reserved.
//

import UIKit
import eBooksModel

// TODO: Move to datasource
let batchSizeKey = "batchSize"

class SearchResultsController: UITableViewController
{
    struct ConfirmationMessage {
        static let added = "Added To Library"
        static let removed = "Removed From Library"
    }

    let iTunesSearchService = SearchService()

    var confirmationController: ConfirmationController? = {
        let popoverController = ConfirmationController.init(nibName: "ConfirmationController", bundle: nil)
        popoverController.modalPresentationStyle = .overCurrentContext
        return popoverController
    }()

    var searchTerms: String? {
        didSet {
            performiTunesSearch()
        }
    }

    @IBOutlet var dataSource: SearchResultsDataSource!
    @IBOutlet weak var activityBackgroundView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    func showActivityIndicator(_ shouldShow: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = shouldShow

        if shouldShow {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }

        tableView.tableFooterView = shouldShow ? activityBackgroundView : nil
    }

    func performiTunesSearch() {
        //        showActivityIndicator(true)

        guard let searchTerms = searchTerms else {
            // TODO: Present modal error message
            return
        }

        iTunesSearchService.performSearch(with: searchTerms) { [weak self] result in
            switch result {
            case .error(let error): self?.presentSearchAlert(with: error.message)
            case .success(let data): OperationQueue.main.addOperation { self?.showSearchResults(with: data) }
            }
        }
    }

    func presentSearchAlert(with errorMessage: String) {
        OperationQueue.main.addOperation {
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .default))
            self.present(alertController, animated: true)
        }
    }

    func searchResultsCell(at indexPath: IndexPath) -> SearchResultsCell {
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchResultsCell else {
            fatalError("Expected cell of type \(SearchResultsCell.self) at index path \(indexPath)")
        }
        return cell
    }

    func showSearchResults(with data: Data) {
        guard
            let json = try? JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0)),
            let jsonDictionary = json as? JsonDictionary
            else {
                // Do something.
                return
        }
        // print(jsonDictionary)
        dataSource.insertManagedObjects(jsonDictionary: jsonDictionary)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.realDestination as? SearchResultsDetailController else {
            return
        }

        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }

        // TODO: update to book(at:)
        let book = dataSource.object(at: indexPath) as? Book

        destination.book = book
    }

    @IBAction func doneViewingBook(segue: UIStoryboardSegue) { }
}

// MARK: - UITableViewDelegate Methods
extension SearchResultsController
{
    // Prevent slide to delete
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = searchResultsCell(at: indexPath)
        let editAction = EditAction(style: .normal, title: "Add") { _, _, handler in
            // TODO: support remove action
            do { try self.addToLibrary(book: self.dataSource.book(at: indexPath), cell: cell) }
            catch { handler(false) }
            handler(true)
        }
        editAction.isAdd = dataSource.book(at: indexPath).isInLibrary

        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    private func addToLibrary(book: Book, cell: SearchResultsCell) throws {
        NotificationCenter.default.post(name: NSNotification.Name.userDidSelectAddBookToLibrary,
                                        object: self,
                                        userInfo: ["book": book])
        
        book.isInLibrary = true
        cell.toggleLibraryIcon()
//        presentConfirmation(message: ConfirmationMessage.added)
    }


    private func presentConfirmation(message: String) {
        guard let confirmationController = confirmationController else { return }
        
        confirmationController.messageText = message
        
        present(confirmationController, animated: false, completion: {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
                (confirmationController.view as? ConfirmationView)?.configureTransition()
                self?.dismiss(animated: false)
            })
        })
    }
}

// MARK: Pre-refactoring
extension SearchResultsController
{
    private func tableView_PRE_REFACTORING(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchResultsCell else {
            return nil
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Add") { _, _, handler in
            // TODO: refactor
//            cell.toggleLibraryIcon()
            self.presentConfirmation(message: ConfirmationMessage.added)
            
            do {
                try self.addToLibrary(book: self.dataSource.book(at: indexPath), cell: cell) }
            catch {
                handler(false)
                
            }
            handler(true)
        }
        
        // TODO: refactor
        editAction.image = cell.libraryIcon.isHidden ? .addIcon : .removeIcon
        editAction.backgroundColor = cell.libraryIcon.isHidden ? .addActionBackground : .removeActionBackground
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }

    private func presentConfirmation_PRE_REFACTORING(message: String) {
        guard let confirmationController = confirmationController else { return }
        
        confirmationController.messageText = message
        
        present(confirmationController, animated: false, completion: {
            let transition: CATransition = CATransition()
            transition.duration = 1.0
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            transition.type = .fade
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
                self?.view.window?.layer.add(transition, forKey: nil)
                self?.dismiss(animated: false)
            })
        })
    }
}
