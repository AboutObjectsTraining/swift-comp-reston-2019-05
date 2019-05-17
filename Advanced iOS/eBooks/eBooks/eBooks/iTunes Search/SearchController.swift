//
//  SearchController.swift
//  Readings
//
//  Created by About Objects on 1/21/19.
//  Copyright © 2019 About Objects. All rights reserved.
//

import UIKit
import Network

class SearchController: UIViewController {
    @IBOutlet weak var connectivityView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!

    let networkMonitor = NWPathMonitor()
    let monitorQueue = DispatchQueue(label: "Monitor")

    var searchResultsController: SearchResultsController? {
        return children.first as? SearchResultsController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self

        networkMonitor.pathUpdateHandler = { [weak self] path in
            self?.toggleConnectivityView(hidden: path.status == .satisfied)
        }

        networkMonitor.start(queue: monitorQueue)
    }

    func toggleConnectivityView(hidden: Bool) {
        OperationQueue.main.addOperation {
            self.connectivityView.isHidden = hidden
        }
    }

    @IBAction func cancelSearch(segue: UIStoryboardSegue) { }
}

extension SearchController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchResultsController?.searchTerms = searchBar.text
        searchBar.resignFirstResponder()
    }
}
