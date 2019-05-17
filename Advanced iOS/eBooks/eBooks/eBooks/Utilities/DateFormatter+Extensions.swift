//
// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
import Foundation

extension DateFormatter
{
    static var year: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        return formatter
    }()
    
    convenience init(withStyle style: Style) {
        self.init()
        self.dateStyle = style
    }
}
