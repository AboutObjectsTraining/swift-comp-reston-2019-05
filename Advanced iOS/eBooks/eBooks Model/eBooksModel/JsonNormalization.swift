// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

public class JsonNormalization: NSObject
{
    struct Keys {
        static let results: String = "results"
        static let artistId: String = "artistId"
        static let genreIds: String = "genreIds"
        static let genres: String = "genres"
    }
    
    static let artistPrefix: String = "artist"
    static let genrePrefix: String = "genre"
    
    public class func authorsJson(jsonDictionary: JsonDictionary) -> JsonArray {
        return jsonDictionary.normalizedAuthorsJson
    }
}

private extension Dictionary where Key == String, Value == Any
{
    var artistId: Int {
        if let artistId = self[JsonNormalization.Keys.artistId] as? Int { return artistId }
        fatalError("Invalid or missing value for key \(JsonNormalization.Keys.artistId) in iTunes Search JSON response.")
    }
    
    var authorsJson: JsonArray {
        if let results = self[JsonNormalization.Keys.results] as? JsonArray  { return results }
        fatalError("Invalid or missing value for key \(JsonNormalization.Keys.results) in iTunes Search JSON response.")
    }
    
    var normalizedAuthorsJson: JsonArray {
        return authorsJson.uniqueAuthors.map { (author: JsonDictionary) -> JsonDictionary in
            let books = authorsJson.books.matching(author.artistId)
            var newAuthor: JsonDictionary = author
            newAuthor["books"] = books
            return newAuthor
        }
    }
    
    var genresJson: JsonArray {
        guard let ids = self[JsonNormalization.Keys.genreIds] as? [String],
            let names = self[JsonNormalization.Keys.genres] as? [String] else { return [] }
        let genres = zip(ids, names).map { id, name in
            [Genre.Keys.genreId: id, Genre.Keys.name: name]
        }
        return genres
    }
}

private extension String {
    func hasGenrePrefix() -> Bool { return hasPrefix(JsonNormalization.genrePrefix) }
    func hasArtistPrefix() -> Bool { return hasPrefix(JsonNormalization.artistPrefix) }
    func isArtistIdKey() -> Bool { return self == JsonNormalization.Keys.artistId }
    func isGenreIdKey() -> Bool { return self == JsonNormalization.Keys.genreIds }
}

private extension Array where Element == JsonDictionary
{
    var uniqueAuthors: JsonArray {
        let allAuthors = map { $0.filter { key, value in key.hasArtistPrefix() }}
        var uniqueIds = Set(allAuthors.map { return $0.artistId })
        var uniqueAuthors: JsonArray = []
        for author in allAuthors {
            if uniqueIds.contains(author.artistId) {
                uniqueAuthors.append(author)
                uniqueIds.remove(author.artistId)
            }
        }
        return uniqueAuthors
    }
    
    var books: JsonArray {
        return map { jsonDictionary in
            var bookInfo = jsonDictionary.filter { key, value in !(key.hasArtistPrefix() && !key.isArtistIdKey()) }
            let info = bookInfo.genresJson
            bookInfo[JsonNormalization.Keys.genres] = info
            bookInfo.removeValue(forKey: JsonNormalization.Keys.genreIds)
            return bookInfo
        }
    }
    
    func matching(_ artistId: Int?) -> JsonArray {
        return filter { $0.artistId == artistId }
    }
}
