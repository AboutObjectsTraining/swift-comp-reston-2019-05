// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

@objc public protocol StringTransformable {
    func stringValue(_ value: Any?) -> Any?
    func objectValue(_ value: Any?) -> Any?
}
