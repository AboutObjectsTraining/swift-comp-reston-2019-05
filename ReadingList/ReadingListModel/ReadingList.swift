//
// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
import Foundation

open class ReadingList: ModelObject
{
    public struct Keys {
        public static let title = #selector(getter: ReadingList.title).description
        public static let books = #selector(getter: ReadingList.books).description
        static var all: [String] { return [title, books] }
    }
    
    @objc open var title = ""
    @objc open private(set) var books = [Book]()
    
    open override var description: String {
        var s = "Title: \(title)\nCount: \(books.count)\nBooks:\n------\n"
        for (index, book) in books.enumerated() {
            s += "\(index + 1). \(book)\n"
        }
        return s
    }
    
    open override class var keys: [String] {
        return Keys.all
    }
    
    open override func setValue(_ value: Any?, forKey key: String) {
        var books: [Book]?
        if key == Keys.books, let dicts = value as? [JsonDictionary] {
            books = dicts.map { Book(dictionary: $0) }
        }
        super.setValue(books ?? value, forKey: key)
    }
    
    open override var dictionaryRepresentation: JsonDictionary {
        var dict = super.dictionaryRepresentation
        if let books = dict[Keys.books] as? [ModelObject] {
            dict[Keys.books] = books.map { $0.dictionaryRepresentation }
        }
        return dict
    }
}

// MARK: - Books array accessors
extension ReadingList
{
    open func book(at indexPath: IndexPath) -> Book { return books[indexPath.row] }
    open func insert(book: Book, at indexPath: IndexPath) { books.insert(book, at: indexPath.row) }
    open func removeBook(at indexPath: IndexPath) { books.remove(at: indexPath.row) }
    open func moveBook(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let book = self.book(at: sourceIndexPath)
        removeBook(at: sourceIndexPath)
        insert(book: book, at: destinationIndexPath)
    }
}
