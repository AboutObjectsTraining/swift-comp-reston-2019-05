//
// Copyright (C) 2016 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
import XCTest

class ControlFlowLabTests: XCTestCase
{
    func testConditional() {
        if shirts.count > 1 {
            print(shirts[1])
        }
    }

    func testConditionals() {
        if polos.price > 9.99, polos.quantity > 1 {
            print(formatted(item: polos))
        }
    }
    
    func testGuard() {
        guard polos.name == "polos" else {
            print("Not polo shirts")
            return
        }
        
        print(formatted(item: polos))
    }
    
    // Instructions: write a discount(item:) function
    //
    func testGuardCaseLet() {
        for shirt in shirts {
            let value = discount(shirt: shirt)
            print(String(format: "%.2f%%", value))
        }
    }
    
    // Instructions: define global let constant named `shirts`
    //
    func testForLoop() {
        var total = 0.0
        for currItem in shirts {
            let (text, amount) = formatted(item: currItem)
            total += amount
            print(text)
        }
        print("total: \(total)")
    }

    func testForLoopWithWhereClause() {
        var total = 0.0
        for currItem in shirts where currItem.price < 60 {
            let (text, amount) = formatted(item: currItem)
            total += amount
            print(text)
        }
        print("total: \(total)")
    }
    
    func testForLoopWithCaseLet() {
        var total = 0.0
        for case let (_, price, quantity) in shirts {
            total += price * Double(quantity)
        }
        print("total: \(total)")
    }
    
    // Instructions: write a `formatted(items:)` function
    //
    func testForLoopWithTuple() {
        var total = 0.0
        for (text, amount) in formatted(items: shirts) {
            total += amount
            print(text)
        }
        print("total: \(total)")
    }
    
    func testSwitch() {
        for currItem in shirts
        {
            switch currItem.quantity {
            case 0, 1: print("One or none")
            case 2: print("Two")
            case 3: print("Three")
            case 4..<12: print("Less than a dozen")
            default: print("More than a dozen")
            }
        }
    }
    
    func testSwitchWithTuples() {
        for currItem in shirts
        {
            switch currItem {
            case let (_, _, quantity) where quantity < 3:
                print("Low quantity: \(currItem.name)")
            case let (_, price, quantity) where quantity > 2 && price < 60:
                print("High quantity, low price: \(currItem.name)")
            default: break
            }
        }
    }
    
    func testSwitchWithText() {
        for currItem in shirts
        {
            switch currItem.name {
            case "tees": print("Tee Shirts")
            case "polos": print("Polo Shirts")
            case "buttondowns": print("Buttondowns")
            default: break
            }
        }
    }
}
