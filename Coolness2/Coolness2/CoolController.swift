// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.a
// See LICENSE.txt for this project's licensing information.

import UIKit

extension CoolController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("In \(#function)")
        textField.resignFirstResponder()
        return true
    }
}

class CoolController: UIViewController
{
    static let coolFieldNib = UINib(nibName: "CoolField", bundle: nil)
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // loadTextFields()
    }
    
    private func loadTextFields() {
        for index in 1...3 {
            guard
                let topLevelObjs = CoolController.coolFieldNib.instantiate(withOwner: nil, options: nil) as? [UITextField],
                let field = topLevelObjs.first
                else { fatalError("CoolField nib doesn't contain a textfield") }
            view.addSubview(field)
            field.frame = field.frame.offsetBy(dx: 20, dy: CGFloat(index * 60))
        }
    }
    
    @IBAction func addCell() {
        print("In \(#function)")
        let newCell = CoolViewCell()
        newCell.text = textField.text
        contentView.addSubview(newCell)
    }
    
    private func loadView3() {
        Bundle.main.loadNibNamed("CoolStuff", owner: self, options: nil)
    }
    
    private func loadView2() {
        guard let topLevelObjs = Bundle.main.loadNibNamed("CoolStuff", owner: nil, options: nil) else { return }
        view = topLevelObjs.first as? UIView
    }
    
    private func loadView1() {
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
        
        textField.delegate = self
        
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

