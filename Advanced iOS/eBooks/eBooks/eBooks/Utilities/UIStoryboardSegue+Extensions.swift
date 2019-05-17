//
//  UIStoryboardSegue+Extensions.swift
//  Readings
//
//  Created by About Objects on 1/22/19.
//  Copyright © 2019 About Objects. All rights reserved.
//

import UIKit

extension UIStoryboardSegue {
    var realDestination: UIViewController? {
        guard let navController = destination as? UINavigationController else {
            return destination
        }
        return navController.children.first
    }
}
