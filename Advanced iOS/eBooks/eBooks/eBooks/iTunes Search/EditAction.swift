//
//  EditAction.swift
//  eBooks
//
//  Created by Rich Kolasa on 2/3/19.
//  Copyright © 2019 About Objects. All rights reserved.
//

import UIKit

class EditAction: UIContextualAction
{
    var isAdd: Bool = true {
        didSet {
            image = isAdd ? .removeIcon : .addIcon
            backgroundColor = isAdd ? .removeActionBackground : .addActionBackground
        }
    }
}
