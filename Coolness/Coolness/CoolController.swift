// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.a
// See LICENSE.txt for this project's licensing information.

import UIKit

class CoolController: UIViewController
{
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.brown
        
        let subview1 = CoolViewCell(frame: CGRect(x: 20, y: 60, width: 200, height: 40))
        let subview2 = CoolViewCell(frame: CGRect(x: 40, y: 120, width: 200, height: 40))
        
        view.addSubview(subview1)
        view.addSubview(subview2)
        
        subview1.text = "Hello 🌏🌎👻!"
        subview2.text = "CoolViewCells rock! 🍾🎉"
        
        subview1.backgroundColor = UIColor.purple
        subview2.backgroundColor = UIColor.orange
    }
}

