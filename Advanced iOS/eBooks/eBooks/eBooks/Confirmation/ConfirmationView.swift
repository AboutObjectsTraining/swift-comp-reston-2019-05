// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import UIKit

class ConfirmationView: UIView
{
    static let transition: CATransition = {
        let transition: CATransition = CATransition()
        transition.duration = 1.0
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        return transition
    }()
    
    func configureTransition() {
        window?.layer.add(ConfirmationView.transition, forKey: nil)
    }
}
