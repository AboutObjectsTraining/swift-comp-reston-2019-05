//
// Copyright (C) 2016 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
import Foundation

extension Double
{
    var dollarAmount: String {
        return String(format: "$%.2f", self)
    }
}


class Cart: CustomStringConvertible
{
    var items: [Item] = []
    
    init() { }
    
    init(items: [Item]) {
        self.items = items
    }
    
    func add(item: Item) {
        items.append(item)
    }
    
    var description: String {
        return items.description
    }
    
    var amount: Double {
        var total = 0.0
        for item in items { total += item.amount }
        return total
    }
    var discountAmount: Double {
        var total = 0.0
        for item in items { total += item.discountAmount }
        return total
    }
    
    class Item: CustomStringConvertible
    {
        let name: String
        let price: Double
        var quantity: Int
        var onSale = false
        
        init(name: String, price: Double, quantity: Int, onSale: Bool = false) {
            self.name = name
            self.price = price
            self.quantity = quantity
            self.onSale = onSale
        }
        
        var amount: Double {
            return price * Double(quantity)
        }
        
        var discount: Double {
            return amount < 100 ? 5 : fmin(amount/20, 30)
        }
        
        var discountAmount: Double {
            return onSale ? amount * (discount/100) : 0
        }
        
        var description: String {
            let discountedAmount = (amount - discountAmount).dollarAmount
            return "\(quantity) \(name) @ $\(price) = \(discountedAmount)"
        }
    }
}
