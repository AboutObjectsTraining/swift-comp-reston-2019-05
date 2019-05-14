//
//  StructAccessorTests.swift
//  SwiftProgramming
//
//  Created by Jonathan Lehr on 2/14/17.
//  Copyright © 2017 About Objects. All rights reserved.
//

import XCTest

@testable import SwiftProgramming

class Shape {
    var position = Point(x: 0, y: 0)
}

class StructAccessorTests: XCTestCase
{
    func testStructAccessors() {
        let shape1 = Shape()
        var point1 = shape1.position
        point1.x = 12.0
        print("\(point1), \(shape1.position)")
        withUnsafePointer(to: &point1) { print($0) }
        withUnsafePointer(to: &shape1.position) { print($0) }
        withUnsafePointer(to: &shape1.position.y) { print($0) }
        
        shape1.position.x += 3
        print("\(point1), \(shape1.position)")
        withUnsafePointer(to: &shape1.position) {
            print($0)
        }
        withUnsafePointer(to: &shape1.position.x) {
            print($0)
        }
    }
}

// Conceptually, an Account is an object that has a lifecycle, so make it a class
class Account {
    var accountId: String
    init(accountId: String) {
        self.accountId = accountId
    }
}

// Theoretically, we're advised to use structs for model objects
struct Customer {
    var name: String
    var account: Account
}

class StructMutabilityTests: XCTestCase
{
    // Problem is, although structs are copied on the stack, if they contain reference
    // types, they still have shared state. We'd have to manually add code to support
    // copy-on-write semantics on a case-by-case basis to avoid this.
    //
    func testMutatingNestedClassInstance() {
        let account = Account(accountId: "Checking")
        let customer1 = Customer(name: "Fred", account: account)
        print(customer1.account.accountId)
        
        let customer2 = customer1
        customer2.account.accountId = "Savings"
        print(customer1.account.accountId)
    }
}

struct Position: Equatable, Hashable {
    var x: Int
    var y: Int
}

enum Weather: Equatable, Hashable {
    case sunny
    case cloudy
    case rain(likelihood: Int)
}

class EquatableTests: XCTestCase
{
    func testEquatableStruct() {
        let pos1 = Position(x: 3, y: 4)
        let pos2 = Position(x: 3, y: 4)
        let pos3 = Position(x: 1, y: 1)
        
        print(pos1 == pos2)
        print(pos1 == pos3)
    }
    
    func testEquatableEnum() {
        print(Weather.sunny == Weather.sunny)
        print(Weather.sunny == Weather.cloudy)
        print(Weather.rain(likelihood: 80) == Weather.rain(likelihood: 80))
        print(Weather.rain(likelihood: 80) == Weather.rain(likelihood: 70))
    }
}
