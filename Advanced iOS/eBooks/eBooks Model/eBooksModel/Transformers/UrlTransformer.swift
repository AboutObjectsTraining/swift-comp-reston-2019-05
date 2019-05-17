// Copyright (C) 2018 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

@objc open class UrlTransformer: ValueTransformer
{
    public static let transformerName = NSValueTransformerName("URL")
    
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

extension UrlTransformer: StringTransformable
{
    open func stringValue(_ value: Any?) -> Any? {
        guard let url = value as? URL else { return value }
        return url.absoluteString
    }
    
    open func objectValue(_ value: Any?) -> Any? {
        guard let string = value as? String else { return value }
        return URL(string: string)
    }
}
