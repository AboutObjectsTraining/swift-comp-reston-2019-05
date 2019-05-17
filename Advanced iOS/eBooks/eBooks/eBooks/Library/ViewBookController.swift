//  Created by About Objects on 1/21/19.
//  Copyright © 2019 About Objects. All rights reserved.

import UIKit
import eBooksModel

class ViewBookController: UITableViewController
{
    var book: Book?
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coverImageView.image = book?.thumbnailImage as? UIImage ?? UIImage.defaultCoverImage
        titleLabel.text = book?.title
        yearLabel.text = DateFormatter.year.string(from: book?.releaseDate as? Date ?? Date())
        authorLabel.text = book?.author?.name
        if ratingLabel != nil {
            ratingLabel.text = "\(book?.ratingCount?.description ?? "") \(book?.averageRating?.stars ?? "unrated")"
        }
        if priceLabel != nil {
            priceLabel.text = book?.price?.stringValue
        }
    }
    
    @IBAction func cancelEditBook(segue: UIStoryboardSegue) { }
}
