//
// Copyright (C) 2016 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
import Foundation

// MARK: Added for TuplesLabTests

func calculatedAmount(item: (_: String, price: Double, quantity: Int)) -> Double {
    return item.price * Double(item.quantity)
}

typealias LineItem = (name: String, price: Double, quantity: Int)

func amount(item: LineItem) -> Double {
    return item.price * Double(item.quantity)
}

func formatted(item: LineItem) -> (text: String, amount: Double) {
    let amount = calculatedAmount(item: item)
    let text = "\(item.quantity) \(item.name) at $\(item.price) = $\(amount)"
    return (text, amount)
}

func formatted(items: [LineItem]) -> [(String, Double)] {
    var formattedItems: [(String, Double)] = []
    for item in items {
        formattedItems.append(formatted(item: item))
    }
    return formattedItems
}

func discount(shirt: LineItem) -> Double {
    guard case let amount = calculatedAmount(item: shirt), amount > 99 else {
        return 5
    }
    return fmin(amount/20, 30)
}


extension Array where Element == LineItem
{
    func formattedLineItems() -> [(String, Double)] {
        var formattedItems: [(String, Double)] = []
        for item in self {
            formattedItems.append(formatted(item: item))
        }
        return formattedItems
    }
    
    func formattedLineItems2() -> [(String, Double)] {
        return map { formatted(item: $0) }
    }
}
