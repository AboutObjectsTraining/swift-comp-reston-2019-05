//
//  Examples.swift
//  Examples
//
//  Created by Jonathan Lehr on 2/14/17.
//  Copyright © 2017 About Objects. All rights reserved.
//

import XCTest

func area(size: (Double, Double)) -> Double {
    return size.0 * size.1
}

// Tuple parameter type difficult to read
func areaB(size: (width: Double, height: Double)) -> Double {
    return size.width * size.height
}

// Declare a typealias named 'Size'
typealias Size = (width: Double, height: Double)

// Using 'Size' typealias streamlines function prototype
func areaC(size: Size) -> Double {
    return size.width * size.height
}

func discounted(_ price: Double, _ discount: Double) -> (Double, Double) {
    let amount = price * discount
    return (price - amount, amount)
}

class TupleTests: XCTestCase
{
    func testTuples()
    {
        let labeledVals = (x: 12, y: "Hi")
        print(labeledVals.x)  // prints "12"
        print(labeledVals.y)  // prints "Hi"
        
        let (price, discount) = discounted(25.00, 0.15)
        print(price)            // prints "21.25"
        print(discount)         // prints "3.75"
        
        let vals = discounted(12.00, 0.25)
        print(vals.0)
        print(vals.1)
        
        let area1 = area(size: (12.5, 14))
        print(area1)
    }
}
