// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

extension NSNumber
{
    enum Stars: Int, CustomStringConvertible {
        case zero, one, two, three, four, five
        init(rating: Int?) {
            self = Stars(rawValue: rating ?? 0) ?? .zero
        }
        var description: String {
            switch self {
            case .zero:  return "☆☆☆☆☆"
            case .one:   return "★☆☆☆☆"
            case .two:   return "★★☆☆☆"
            case .three: return "★★★☆☆"
            case .four:  return "★★★★☆"
            case .five:  return "★★★★★"
            }
        }
    }
    
    var stars: String {
        return Stars(rating: self as? Int).description
    }
}
