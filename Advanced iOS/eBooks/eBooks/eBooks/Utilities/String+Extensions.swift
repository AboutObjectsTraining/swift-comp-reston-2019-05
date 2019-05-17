//
//  String+Extensions.swift
//  Readings
//
//  Created by About Objects on 1/22/19.
//  Copyright © 2019 About Objects. All rights reserved.
//

import Foundation

extension String {
    static func htmlDocumentString(with content: String) -> String? {
        guard let path = Bundle.main.path(forResource: "synopsis", ofType: "html") else {
            return nil
        }
        let htmlString = try? String(contentsOfFile: path, encoding: .utf8)
        return htmlString?.replacingOccurrences(of: "#BODY#", with: content)
    }
}
