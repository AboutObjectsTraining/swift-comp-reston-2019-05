//
//  SearchResultsDetailController.swift
//  Readings
//
//  Created by About Objects on 1/21/19.
//  Copyright © 2019 About Objects. All rights reserved.
//

import UIKit
import WebKit
import eBooksModel

class SearchResultsDetailController: UIViewController {

    var book: Book?

    @IBOutlet weak var synopsisWebView: WKWebView!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewBookController = segue.realDestination as? ViewBookController
        viewBookController?.book = book
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synopsisWebView.navigationDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard
            let synopsis = book?.synopsis,
            let htmlString = String.htmlDocumentString(with: synopsis) else {
            return
        }
        synopsisWebView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
    }
}

private let jsString =
    "var style = document.createElement('style'); "
    + "style.innerHTML = '%@'; "
    + "document.head.appendChild(style);"

extension SearchResultsDetailController: WKNavigationDelegate
{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard
            let path = Bundle.main.path(forResource: "style", ofType: "css"),
            let css = try? String(contentsOfFile: path).replacingOccurrences(of: "\\n", with: "", options: .regularExpression)
            else { return }
        synopsisWebView.evaluateJavaScript(String(format: jsString, css))
    }
}
