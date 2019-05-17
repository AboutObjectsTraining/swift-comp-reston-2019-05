// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import UIKit
import ReadingListModel

class ReadingListDataSource: NSObject
{
    @IBOutlet var storeController: ReadingListStore!
    
    lazy var readingList = storeController.fetchedReadingList
}


extension ReadingListDataSource: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readingList.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Book Summary") else {
            fatalError("Missing reuse identifier in storyboard.")
        }
        let book = readingList.book(at: indexPath)
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = "\(book.year ?? "   ") \(book.author?.fullName ?? "Unknown")"
        return cell
    }
}
