//
//  ViewController.swift
//  FadingButton
//
//  Created by Jonathan Lehr on 5/15/19.
//  Copyright © 2019 About Objects. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var goodbyeLabel: UILabel!
    @IBOutlet weak var helloLabel: UILabel!
    
    @IBAction func startAnimating() {
        UIView.animateKeyframes(withDuration: 1.25,
                                delay: 0,
                                options: [.repeat, .autoreverse],
                                animations: { self.configureFadeAnimation() })
    }
    
    func configureFadeAnimation() {
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
            self.helloLabel.alpha = 0
        }
        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
            self.goodbyeLabel.alpha = 1
        }
    }
}

