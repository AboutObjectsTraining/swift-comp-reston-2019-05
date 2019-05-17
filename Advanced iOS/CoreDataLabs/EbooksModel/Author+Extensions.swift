// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import CoreData


extension Author
{
    static let booksKey = "books"
    
    public override func setValuesForKeys(_ keyedValues: [String : Any]) {
        let attributeValues = keyedValues.filter { $0.key != Author.booksKey }
        super.setValuesForKeys(attributeValues)
        
        guard let ctx = managedObjectContext,
            let bookDicts = keyedValues[Author.booksKey] as? [[String: Any]] else {
            return
        }
        
        let books: [Book] = bookDicts.map { [weak self] in
            let book = Book(dictionary: $0, context: ctx)
            book.author = self
            return book
        }
        super.setValue(NSOrderedSet(array: books), forKey: Author.booksKey)
    }
}
