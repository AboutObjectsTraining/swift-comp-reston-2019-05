// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.a
// See LICENSE.txt for this project's licensing information.

import UIKit

class CoolController: UIViewController
{
}


// MARK: - Dead code (examples)
extension CoolController
{
    private func loadView3() {
        Bundle.main.loadNibNamed("CoolStuff", owner: self, options: nil)
    }
    
    private func loadView2() {
        guard let topLevelObjs = Bundle.main.loadNibNamed("CoolStuff", owner: nil, options: nil) else { return }
        view = topLevelObjs.first as? UIView
    }
}

