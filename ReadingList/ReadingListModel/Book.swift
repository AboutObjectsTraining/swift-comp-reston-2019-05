//
// Copyright (C) 2017 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
import Foundation

open class Book: ModelObject
{
    public struct Keys {
        public static let title = #selector(getter: Book.title).description
        public static let year = #selector(getter: Book.year).description
        public static let author = #selector(getter: Book.author).description
        static var all: [String] { return [title, year, author] }
    }
    
    @objc open var title: String?
    @objc open var year: String?
    @objc open var author: Author?
    
    open override var description: String {
        return "title: \(title ?? "nil"), year: \(year ?? "nil"), author: \(author?.description ?? "nil")"
    }
    
    open override class var keys: [String] {
        return Keys.all
    }
    
    public required init(dictionary: JsonDictionary) {
        var bookInfo = dictionary
        if let authorInfo = dictionary[Keys.author] as? JsonDictionary {
            bookInfo[Keys.author] = Author(dictionary: authorInfo)
        }
        super.init(dictionary: bookInfo)
    }
    
    open override var dictionaryRepresentation: JsonDictionary {
        var dict = super.dictionaryRepresentation
        if let author = dict[Keys.author] as? Author {
            dict[Keys.author] = author.dictionaryRepresentation as Any?
        }
        return dict
    }
}

