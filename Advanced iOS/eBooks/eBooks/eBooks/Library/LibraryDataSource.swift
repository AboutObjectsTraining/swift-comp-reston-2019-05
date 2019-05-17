// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import os
import CoreData
import eBooksModel

class LibraryDataSource: DataSource
{
    @IBOutlet weak var searchService: SearchService!
    
    override var entityName: String { return Book.entityName }
    override var sectionNameKeyPath: String? { return "author.name" }
    override var sortDescriptors: [NSSortDescriptor]? { return [NSSortDescriptor(key: "title", ascending: true)] }
    override var cacheName: String? { return "Library Cache" }
    
    override func reuseIdentifier(for cellAt: IndexPath) -> String {
        return "Library Cell"
    }
    
    override func populate(cell: UITableViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? LibraryCell else { fatalError("Unable to obtain instance of \(LibraryCell.self)") }
        let obj = fetchedResultsController.object(at: indexPath)
        let book = obj as? Book  // else { fatalError("Unable to obtain book at index path \(indexPath)") }
        cell.titleLabel.text = book?.title
        
        if let thumbnailImage = book?.thumbnailImage as? UIImage {
            cell.thumbnailImageView.image = thumbnailImage
        }
        else {
            searchService.fetchThumbnailImage(for: book)
        }
    }
}
