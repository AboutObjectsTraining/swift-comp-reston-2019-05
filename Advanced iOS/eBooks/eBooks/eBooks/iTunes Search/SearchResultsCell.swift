//
//  SearchResultsCell.swift
//  Readings
//
//  Created by About Objects on 1/21/19.
//  Copyright © 2019 About Objects. All rights reserved.
//

import UIKit

class SearchResultsCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var libraryIcon: UIImageView!

    var shouldShowLibraryIcon: Bool = false {
        didSet { libraryIcon.isHidden = !shouldShowLibraryIcon }
    }

    func toggleLibraryIcon() {
        libraryIcon.isHidden.toggle()
    }
}
