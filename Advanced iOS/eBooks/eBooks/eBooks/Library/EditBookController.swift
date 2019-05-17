//
//  EditBookController.swift
//  Readings
//
//  Created by About Objects on 1/21/19.
//  Copyright © 2019 About Objects. All rights reserved.
//

import UIKit

class EditBookController: UITableViewController {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet var accessoryToolbar: UIToolbar!

    override var inputAccessoryView: UIView? {
        return accessoryToolbar
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        view.endEditing(true)
    }

    @IBAction func undo(_ sender: UIBarButtonItem) { }
    @IBAction func redo(_ sender: UIBarButtonItem) { }

    @IBAction func cancelSelectAuthor(segue: UIStoryboardSegue) { }

}
