// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import UIKit

extension UIStoryboardSegue
{
    var realDestination: UIViewController? {
        guard let navController = destination as? UINavigationController else {
            return destination
        }
        return navController.children.first
    }
}
