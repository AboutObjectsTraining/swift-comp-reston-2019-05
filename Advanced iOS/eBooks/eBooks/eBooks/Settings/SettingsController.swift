//
//  SettingsController.swift
//  eBooks
//
//  Created by Rich Kolasa on 1/24/19.
//  Copyright © 2019 About Objects. All rights reserved.
//

import UIKit
import SafariServices

class SettingsController: UITableViewController {
    @IBOutlet weak var offlineSwitch: UISwitch! {
        didSet {
            offlineSwitch.isOn = UserDefaults.isOffline
        }
    }

    @IBAction func offlineToggled(_ sender: UISwitch) {
        UserDefaults.isOffline = sender.isOn
    }

    @IBAction func loadIcons8(_ sender: Any) {
        guard let url = URL(string: "https://www.icons8.com") else {
            return
        }
        let controller = SFSafariViewController(url: url)
        present(controller, animated: true)
    }
}
