// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.

import Foundation

private let mockJsonFileName = "iTunesSearchResult"

/// `HttpsProtocol` is a `URLProtocol` sublcass responsible for intercepting HTTPS requests
/// and replacing them with requests to the file system.
///
/// * **requestHandledKey** is set within the `URLRequest` to prevent an infinite loop.
///
class HttpsProtocol: URLProtocol
{
    static let requestHandledKey = "is_handled"
    var dataTask: URLSessionDataTask?

    override class func canInit(with request: URLRequest) -> Bool {
        if !UserDefaults.isOffline { return false }
        if URLProtocol.property(forKey: requestHandledKey, in: request) as? Bool == true { return false }
        
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let fileUrlRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else { return }
        URLProtocol.setProperty(true, forKey: HttpsProtocol.requestHandledKey, in: fileUrlRequest)

        guard let path = Bundle.main.path(forResource: mockJsonFileName, ofType: "json") else { return }
        fileUrlRequest.url = URL(fileURLWithPath: path)

        // The cast to URLRequest below is needed due to a bug related to Swift interop support for NSMutableURLRequest.
        dataTask = substitutedDataTask(for: fileUrlRequest as URLRequest)
        dataTask?.resume()
    }

    // Mandatory override
    override func stopLoading() { }

    private func substitutedDataTask(for fileUrlRequest: URLRequest) -> URLSessionDataTask {
        let dataTask = URLSession.shared.dataTask(with: fileUrlRequest, completionHandler: { (data, response, error) in
            guard
                let data = data,
                let url = self.request.url,
                let newResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else {
                    self.client?.urlProtocol(self, didFailWithError: NSError(domain: "MockResponseError", code: 42, userInfo: nil))
                    return
            }

            self.client?.urlProtocol(self, didReceive: newResponse, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
        })

        return dataTask
    }
}
