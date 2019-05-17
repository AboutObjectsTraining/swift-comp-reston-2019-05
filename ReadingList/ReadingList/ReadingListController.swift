// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import UIKit
import ReadingListModel

class ReadingListController: UITableViewController
{
    @IBOutlet var dataSource: ReadingListDataSource!
    
    @IBAction func done(unwindSegue: UIStoryboardSegue) {
        dataSource.save()
        tableView.reloadData()
    }
    
    @IBAction func cancel(unwindSegue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.realDestination as? BookDetailController,
            let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("destination must be \(BookDetailController.self)")
        }
        
        controller.book = dataSource.book(at: indexPath)
    }
}


//extension ReadingListController
//{
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 100
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Book Summary") else {
//            fatalError("Check the reuse identifier in the storyboard.")
//        }
//        cell.textLabel?.text = "Row \(indexPath.row + 1)"
//        return cell
//    }
//}
