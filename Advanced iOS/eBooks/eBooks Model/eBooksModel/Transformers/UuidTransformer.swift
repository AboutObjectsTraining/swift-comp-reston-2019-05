// Copyright (C) 2018 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

@objc open class UuidTransformer: ValueTransformer
{
    public static let transformerName = NSValueTransformerName("UUID")
    
    override open class func allowsReverseTransformation() -> Bool { return true }
    
    override open func transformedValue(_ value: Any?) -> Any? {
        guard let string = stringValue(value) as? String else { return nil }
        return string.data(using: .utf8)
    }
    override open func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data, let string = String(data: data, encoding: .utf8) else { return nil }
        return UUID(uuidString: string)
    }
}

extension UuidTransformer: StringTransformable
{
    public func stringValue(_ value: Any?) -> Any? {
        guard let uuid = value as? UUID else { return nil }
        return uuid.uuidString
    }
    
    public func objectValue(_ value: Any?) -> Any? {
        guard let string = value as? String else { return nil }
        return UUID(uuidString: string)
    }
}
