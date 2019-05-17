// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import UIKit

class ReadingListController: UITableViewController
{
    @IBAction func done(unwindSegue: UIStoryboardSegue) {
        // TODO: sync the UI and save changes
    }
    
    @IBAction func cancel(unwindSegue: UIStoryboardSegue) {
        
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
