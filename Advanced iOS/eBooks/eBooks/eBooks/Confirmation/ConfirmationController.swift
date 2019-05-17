//
//  ConfirmationController.swift
//  Readings
//
//  Created by About Objects on 1/22/19.
//  Copyright © 2019 About Objects. All rights reserved.
//

import UIKit

class ConfirmationController: UIViewController {
    var messageText = ""

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            messageLabel.text = messageText
        }
    }
    
    @IBOutlet weak var visualEffectsView: UIVisualEffectView! {
        didSet {
            visualEffectsView.layer.cornerRadius = 10
            visualEffectsView.clipsToBounds = true
        }
    }
}
