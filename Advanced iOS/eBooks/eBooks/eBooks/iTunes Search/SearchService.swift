//
//  iTunesSearchService.swift
//  eBooks
//
//  Created by Rich Kolasa on 1/28/19.
//  Copyright © 2019 About Objects. All rights reserved.
//
import os
import Network
import UIKit
import eBooksModel

private let iTunesUrlString = "https://itunes.apple.com/search"

class SearchService: NSObject
{
    struct Keys {
        static let batchSize = "iTunesSearchBatchSize"
    }
    
    struct Messages {
        static let connectivityError = NSLocalizedString("Could not connect to network. Check the network connection and try again.", comment: "Connection error message")
        static let httpError = NSLocalizedString("Connection to iTunes failed. Please try again.", comment: "HTTP error message")
        static let unknown = NSLocalizedString("Please try again.", comment: "Unknown error message")
    }
    
    enum Result {
        case error(Error)
        case success(Data)
    }

    enum Error {
        case connectivityError
        case httpError
        case unknown

        var message: String {
            switch self {
            case .connectivityError: return Messages.connectivityError
            case .httpError:         return Messages.httpError
            case .unknown:           return Messages.unknown
            }
        }
    }

    let monitor = NWPathMonitor()
    
    func performSearch(with terms: String, completion: @escaping (Result) -> Void) {
        let batchSize = UserDefaults.standard.object(forKey: Keys.batchSize)
        var components = URLComponents(string: iTunesUrlString)
        components?.queryItems = [URLQueryItem(name: URLQueryItem.Keys.media, value: "ebook"),
                                  URLQueryItem(name: URLQueryItem.Keys.term, value: terms),
                                  URLQueryItem(name: URLQueryItem.Keys.limit, value: batchSize as? String)]

        guard let url = components?.url else {
            completion(.error(.unknown))
            return
        }

        let searchTask = URLSession.shared.dataTask(with: url) { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            if let data = data, let response = httpResponse {
                completion(response.isSuccess ? .success(data) : .error(.httpError))
            }
        }
        
        searchTask.resume()
    }

    func fetchThumbnailImage(for book: Book?) {
        // TODO: Demo performance issue here...
        //
        // guard let url = book?.thumbnailUrl as? URL else { return }
        //
        guard book?.thumbnailImage == nil,
            let url = book?.thumbnailUrl as? URL else { return }
        
        // ... and here.
        if UserDefaults.isOffline { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, response.isSuccess else {
                return
            }
            OperationQueue.main.addOperation {
                let image = UIImage(data: data) ?? UIImage.defaultCoverImage
                book?.thumbnailImage = image                
            }
        }
        
        task.resume()
    }
}

private extension HTTPURLResponse
{
    struct StatusCodes {
        static let success = 200
    }
    var isSuccess: Bool {
        return statusCode == StatusCodes.success
    }
}

private extension URLQueryItem
{
    struct Keys {
        static let media = "media"
        static let term = "term"
        static let limit = "limit"
    }
}
