// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import UIKit
import ReadingListModel

class ReadingListDataSource: NSObject
{
    @IBOutlet var storeController: ReadingListStore!
    
    lazy var readingList = storeController.fetchedReadingList
    
    func book(at indexPath: IndexPath) -> Book {
        return readingList.book(at: indexPath)
    }
    
    func save() {
        storeController.save(readingList: readingList)
    }
}

extension ReadingListDataSource: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readingList.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer) else {
            fatalError("Missing reuse identifier in storyboard.")
        }
        configure(cell: cell, at: indexPath)
        populate(cell: cell, at: indexPath)
        return cell
    }
}

extension ReadingListDataSource
{
    var cellIdentifer: String { return "Book Summary" }
    
    func configure(cell: UITableViewCell, at indexPath: IndexPath) {
    }

    func populate(cell: UITableViewCell, at indexPath: IndexPath) {
        let book = readingList.book(at: indexPath)
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = "\(book.year ?? "   ") \(book.author?.fullName ?? "Unknown")"
    }
}
