// Copyright (C) 2019 About Objects Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

@objc open class DateTransformer: ValueTransformer
{
    public static let transformerName = NSValueTransformerName("Date")
    
    override open class func allowsReverseTransformation() -> Bool { return true }
    
    override open func transformedValue(_ value: Any?) -> Any? {
        guard let stringValue = stringValue(value) as? String else { return value }
        return stringValue.data(using: .utf8)
    }
    override open func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = (value as? Data), let string = String(data: data, encoding: .utf8) else { return value }
        return URL(string: string)
    }
}

extension DateTransformer: StringTransformable
{
    open func stringValue(_ value: Any?) -> Any? {
        guard let date = value as? Date else { return value }
        return iso8601formatter.string(from: date)
    }
    
    open func objectValue(_ value: Any?) -> Any? {
        guard let string = value as? String else { return value }
        return iso8601formatter.date(from: string)
    }
}
