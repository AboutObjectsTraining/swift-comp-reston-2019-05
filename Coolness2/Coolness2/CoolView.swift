// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import UIKit

class CoolView: UIView
{
    @IBOutlet var textField: UITextField!
    
    @IBAction func addCell() {
        print("In \(#function)")
        let newCell = CoolViewCell()
        newCell.text = textField.text
        addSubview(newCell)
    }
}



// MARK: - Nib loading experiment
private let coolFieldNib = UINib(nibName: "CoolField", bundle: nil)
extension CoolView
{
    private func loadTextFields() {
        for index in 1...3 {
            guard
                let topLevelObjs = coolFieldNib.instantiate(withOwner: nil, options: nil) as? [UITextField],
                let field = topLevelObjs.first
                else { fatalError("CoolField nib doesn't contain a textfield") }
            addSubview(field)
            field.frame = field.frame.offsetBy(dx: 20, dy: CGFloat(index * 60))
        }
    }
}
