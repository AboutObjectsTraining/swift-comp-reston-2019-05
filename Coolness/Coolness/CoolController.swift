// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.a
// See LICENSE.txt for this project's licensing information.

import UIKit

class CoolController: UIViewController
{
    var contentView: UIView!
    var textField: UITextField!
    
    @objc func addCell() {
        print("In \(#function)")
        let newCell = CoolViewCell()
        newCell.text = textField.text
        contentView.addSubview(newCell)
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.brown
        
        let (accessoryRect, contentRect) = UIScreen.main.bounds.divided(atDistance: 90, from: .minYEdge)
        let accessoryView = UIView(frame: accessoryRect)
        contentView = UIView(frame: contentRect)
        view.addSubview(accessoryView)
        view.addSubview(contentView)
        
        accessoryView.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
        contentView.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        contentView.clipsToBounds = true

        // Controls
        
        textField = UITextField(frame: CGRect(x: 15, y: 52, width: 240, height: 30))
        accessoryView.addSubview(textField)
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter a label"
        
        let button = UIButton(type: .system)
        accessoryView.addSubview(button)
        button.setTitle("Add", for: .normal)
        button.sizeToFit()
        button.frame = button.frame.offsetBy(dx: 270, dy: 52)
        
        button.addTarget(self, action: #selector(addCell), for: .touchUpInside)
        
        // Cells
        let subview1 = CoolViewCell(frame: CGRect(x: 20, y: 60, width: 200, height: 40))
        let subview2 = CoolViewCell(frame: CGRect(x: 40, y: 120, width: 200, height: 40))
        
        contentView.addSubview(subview1)
        contentView.addSubview(subview2)
        
        subview1.text = "Hello 🌏🌎👻!"
        subview2.text = "CoolViewCells rock! 🍾🎉"
        
        subview1.backgroundColor = UIColor.purple
        subview2.backgroundColor = UIColor.orange
    }
}

