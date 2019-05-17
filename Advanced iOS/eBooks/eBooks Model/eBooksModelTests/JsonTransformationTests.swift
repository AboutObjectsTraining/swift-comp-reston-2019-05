// Copyright (C) 2019 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import XCTest
@testable import eBooksModel

let dictionary: JsonDictionary = {
    let url = Bundle(for: JsonTransformationTests.self).url(forResource: "iTunesSample", withExtension: "json")
    let data = try! Data(contentsOf: url!)
    let json = try! JSONSerialization.jsonObject(with: data, options: [])
    return json as! JsonDictionary
}()


class JsonTransformationTests: XCTestCase
{
    func test_iTunesJsonNormalization() {
        let normalizedJson = JsonNormalization.authorsJson(jsonDictionary: dictionary)
        print(normalizedJson)
        (normalizedJson as NSArray).write(toFile: "/tmp/SampleOutput.plist", atomically: true)
    }
}
