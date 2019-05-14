//
// Copyright (C) 2016 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
import XCTest


func ascending(s1: String, s2: String) -> Bool {
    return s1 < s2
}

let fruit = ["Pear", "Apple", "Peach", "Banana"]


class ClosuresTests: XCTestCase
{
    func testSort() {
        let sortedFruit = fruit.sorted(by: ascending)
        print(sortedFruit)
        
        //  `<` function declaration in Standard Library:
        //
        //  public func <<T : Comparable>(lhs: T, rhs: T) -> Bool
        //
        let sortedFruit2 = fruit.sorted(by: <)
        print(sortedFruit2)
    }
    
    func testSort2()
    {
        // Passing closure argument
        let sortedFruit = fruit.sorted(by: { (s1: String, s2: String) -> Bool in
            return s1 < s2
        })
        print(sortedFruit)

        // Using trailing closure syntax
        let sortedFruit2 = fruit.sorted { (s1: String, s2: String) -> Bool in
            return s1 < s2
        }
        print(sortedFruit2)

        // Using type inference and implicit return
        let sortedFruit3 = fruit.sorted { s1, s2 in
            s1 < s2
        }
        print(sortedFruit3)
        
        // Using positional parameters
        let sortedFruit4 = fruit.sorted { $0 < $1 }
        print(sortedFruit4)
    }

}






