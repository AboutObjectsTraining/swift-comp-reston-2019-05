//
//  Defaults.swift
//  eBooks
//
//  Created by Rich Kolasa on 1/24/19.
//  Copyright © 2019 About Objects. All rights reserved.
//

import Foundation

extension UserDefaults
{
    struct Keys {
        static let offline = "Offline Mode"
        static let SearchConcurrentOperationsCount = "SearchConcurrentOperationsCount"
    }
    
    @objc(ebm_isOffline)
    class var isOffline: Bool {
        get { return UserDefaults.standard.bool(forKey: Keys.offline) }
        set { UserDefaults.standard.setValue(newValue, forKey: Keys.offline) }
    }
    
    @objc(ebm_searchConcurrentOperationsCount)
    class var searchConcurrentOperationsCount: Int {
        get { return UserDefaults.standard.integer(forKey: Keys.SearchConcurrentOperationsCount) }
        set { UserDefaults.standard.setValue(newValue, forKey: Keys.SearchConcurrentOperationsCount) }
    }
}
