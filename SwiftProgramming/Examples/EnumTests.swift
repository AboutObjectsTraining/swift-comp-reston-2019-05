//
//  EnumTests.swift
//  SwiftProgramming
//
//  Created by Jonathan Lehr on 2/14/17.
//  Copyright © 2017 About Objects. All rights reserved.
//

import XCTest

enum Garment: Equatable, CustomStringConvertible {
    case tie
    case shirt(size: String)
    case pants(waist: Int, inseam: Int)
    
    var description: String {
        switch self {
        case .tie:             return "tie"
        case .shirt(let s):    return "shirt: \(s)"
        case .pants(let w, let i): return "pants: \(w)X\(i)"
        }
    }
}

func ==(lhs: Garment, rhs: Garment) -> Bool {
    switch (lhs, rhs) {
    case (.tie, .tie): return true
    case let (.shirt(size1), .shirt(size2)):
        return size1 == size2
    case let (.pants(waist1, inseam1), .pants(waist2, inseam2)):
        return waist1 == waist2 && inseam1 == inseam2
    default: return false
    }
}

func show(item: Garment)
{
    switch item {
    case .tie: print("tie")
    case .shirt(let s): print("shirt, \(s)")
    case .pants(let w, let i): print("pants, \(w)X\(i)")
    }
    
    switch item {
    case .tie: print("tie")
    case let .shirt(s): print("shirt, \(s)")
    case let .pants(w, i): print("pants, \(w)X\(i)")
    }
}

class EnumTests: XCTestCase
{
    
    func testFoo() {
        var bar = [Int]()
        bar.append(contentsOf: 1...5)
        let factorial1 = bar.reduce(1, *)
        print(factorial1)
        
        let vals = Array<Int>(1...5)
        let factorial2 = vals.reduce(1, *)
        print(factorial2)
    }
    
    func testIfCaseLet()
    {
        let item = Garment.shirt(size: "SM")
        
        if case Garment.shirt(let size) = item {
            print(size)
        }
        
        if case let Garment.shirt(size) = item {
            print(size)
        }
        
        if case Garment.shirt = item {
            print("Shirt")
        }
        
        if case let Garment.shirt(size) = item, size == "SM" {
            print("Small shirt")
        }
        
    }
    
    func testAssociatedValues()
    {
//        show(item: Garment.tie)
//        show(item: Garment.shirt(size: "XL"))
//        show(item: Garment.pants(waist: 32, inseam: 34))
        
        print(Garment.tie)
        print(Garment.shirt(size: "XL"))
        print(Garment.pants(waist: 32, inseam: 34))
        
        let items: [Garment] = [.tie,
                                .shirt(size: "XL"),
                                .pants(waist: 32, inseam: 34)]
        for item in items {
            print(item)
        }
        print(items)
    }
    
    func testFilter()
    {
        let garments = [
            Garment.tie,
            Garment.shirt(size: "XL"),
            Garment.pants(waist: 32, inseam: 34)
        ]
        
        let garment = garments.filter {
            $0 == .tie
        }
        
        print(garment)
    }
}
