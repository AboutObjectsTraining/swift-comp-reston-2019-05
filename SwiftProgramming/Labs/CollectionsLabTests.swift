//
// Copyright (C) 2016 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
import XCTest
@testable import SwiftProgramming

class CollectionsLabTests: XCTestCase
{
    func testArray() {
        var items: [String] = []
        print(items)
        XCTAssertEqual(items.count, 0)

        items.append("Apple")
        items.append("Pear")
        print(items)
        XCTAssertEqual(items.count, 2)
        
        items[1] = "Orange"
        print(items)
    }
    
    func testLiteralArray() {
        let items = ["Apple", "Banana"]
        print(items)
        XCTAssertEqual(items.count, 2)
    }
    
    func testOptionals() {
        
        let wrappedX = Int("12")
        if let unwrappedX = wrappedX {
            print(unwrappedX + 2)
        }
        
        switch wrappedX {
        case .none: print("Nada")
        case .some(let x): print(x)
        }
        
//        let foo = wrappedX
//
//        if case .some(let unwrappedX2) = wrappedX {
//
//        }
    }
    
    func testMapValues() {
        let items = ["Apple", "Banana", "🍍"]
        print(items)
        
        let lowercasedItems = items.map { $0.lowercased() }
        print(lowercasedItems)
    }

    func testEnumerateArray() {
        let items = ["Apple", "Banana"]
        print(items)
        
        for item in items {
            print(item)
        }
        
        for (index, item) in items.enumerated() {
            print("item at index \(index) is \(item)")
        }
    }
    
    func testDictionary() {
        var prices: [String: Double] = [:]
        prices["jeans"] = 49.99
        prices["t-shirt"] = 29.99
        print(prices)
    }
    
    func testEnumerateDictionary() {
        var prices: [String: Double] = [:]
        prices["jeans"] = 49.99
        prices["t-shirt"] = 29.99
        print(prices)
        
        for (key, value) in prices {
            print("key is \(key), value is \(value)")
        }
    }
    
    func testEnumerateDictionary2() {
        let prices = ["jeans": 49.99, "t-shirt": 29.99]
        for (key, value) in prices {
            print("price of \(key) is \(value)")
        }
        
        for (itemName, price) in prices {
            print(String(format: "price of \(itemName) is %.3f", price))
        }
        
        print ("items:")
        for (key, _) in prices {
            print(key)
        }
        
        var sum = 0.0
        for (_, price) in prices {
            sum += price
        }
        print("sum is \(sum)")
    }
    
    func testFilterDictionary() {
        var prices: [String: Double] = [:]
        prices["jeans"] = 49.99
        prices["t-shirt"] = 29.99
        print(prices)
        
        let filteredPrices = prices.filter { key, value in key == "jeans" }
        print(filteredPrices)
    }
}
