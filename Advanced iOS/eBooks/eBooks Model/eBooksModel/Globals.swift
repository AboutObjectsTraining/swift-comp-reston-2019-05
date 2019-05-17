// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import Foundation

// Formatters are expensive to set up and tear down, so its best to
// cache instances and reuse them, as we're doing here
public let iso8601formatter: ISO8601DateFormatter = ISO8601DateFormatter()

