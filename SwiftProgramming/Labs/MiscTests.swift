//
//  MiscTests.swift
//  Shopping
//
//  Created by Jonathan Lehr on 10/20/16.
//  Copyright © 2016 About Objects. All rights reserved.
//

import XCTest

enum Garment {
    case shirt
    case pants
    case jacket
}

func showSpecials(garmentType: Garment) {
    switch garmentType {
    case .shirt:
        print("All shirts 15% off this week.")
    case .pants:
        print("Get two pairs for the price of one!")
    default: break
    }
}

func discount(type: Garment) -> Double {
    guard case .shirt = type else {
        return 0.0
    }
    return 0.15
}
func showDiscount(type: Garment) {
    guard case .shirt = type else {
        return
    }
    print("15% discount")
}
func discount2(forGarmentType type: Garment) -> Double {
    return type == .shirt ? 0.15 : 0.0
}
func discount3(forGarmentType type: Garment) -> Double {
    guard case .shirt = type else {
        return 0.0
    }
    return 0.15
}

let supplies = [
    (name: "pencils", price: 0.35, quantity: 12.0),
    (name: "erasers", price: 0.50, quantity: 6.0)
]


class MiscTests: XCTestCase
{
    func testString() {
        let s = "Hello 🌎! 😀"
        let indexes = s.indices
        print(indexes)
        
        for i in indexes {
            print("\(i) \(s[i])")
        }
    }
    
    func testEnum() {
        print(Garment.jacket)
    }
    
    func testSwitch() {
        showSpecials(garmentType: Garment.shirt)
        showSpecials(garmentType: Garment.pants)
        showSpecials(garmentType: Garment.jacket)
    }
    func testGuardCase() {
        showDiscount(type: Garment.shirt)
        showDiscount(type: Garment.pants)
        showDiscount(type: Garment.jacket)
    }
    
    func testForLoopWithWhereClause() {
        for index in 0...5 where index % 2 == 0 {
            print("index is \(index)")
        }
    }
    func testForLoopWithCaseLet() {
        for case let (name, price, quantity) in supplies {
            print("\(name), $\(price * quantity)" )
        }
    }
}

// index is 0
// index is 2
// index is 4


// pencils, $4.2
// erasers, $3.0





func total(shirts: [LineItem]) -> Double {
    var total = 0.0
    for shirt in shirts {
        var (_, amount) = formatted(item: shirt)
        if amount > 100 {
            amount *= 0.9 // Apply 10% discount
        }
        total += amount
    }
    return total
}

func discount1(shirt: LineItem) -> Double {
    if case let amount = calculatedAmount(item: shirt), amount > 100 {
        let discount = amount / 20
        return fmin(discount, 30)
    }
    return 5
}
