// Copyright (C) 2018 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import UIKit

@objc open class ImageTransformer: ValueTransformer
{
    public static let transformerName = NSValueTransformerName("Image")
    public static var compressionQuality: CGFloat = 1.0
    
    override open class func allowsReverseTransformation() -> Bool { return true }
    
    override open func transformedValue(_ value: Any?) -> Any? {
        guard let image = value as? UIImage else { return value }
        return image.jpegData(compressionQuality: ImageTransformer.compressionQuality)
    }
    override open func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return value }
        return UIImage(data: data)
    }
}

extension ImageTransformer: StringTransformable
{
    open func stringValue(_ value: Any?) -> Any? {
        guard let image = value as? UIImage else { return value }
        return image.jpegData(compressionQuality: ImageTransformer.compressionQuality)?.base64EncodedString()
    }
    
    open func objectValue(_ value: Any?) -> Any? {
        guard let string = value as? String, let data = Data(base64Encoded: string) else { return value }
        return UIImage(data: data)
    }
}
