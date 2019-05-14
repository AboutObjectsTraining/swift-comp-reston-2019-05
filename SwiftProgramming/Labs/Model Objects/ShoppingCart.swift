//
//  ShoppingCart.swift
//  Shopping
//
//  Created by Jonathan Lehr on 10/22/16.
//  Copyright © 2016 About Objects. All rights reserved.
//

import Foundation

let cartItems = [
    CartItem(name: "dress shirts", price: 94.95, quantity: 4),
    CartItem(name: "sport shirts", price: 79.99, quantity: 7),
    CartItem(name: "henleys", price: 54.99, quantity: 5),
]

struct CartItem : CustomStringConvertible
{
    let name: String
    let price: Double
    let quantity: Int
    var onSale = false
    
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
        return "\(quantity) \(name) at $\(price) = $\(amount)"
    }
    
    init(name: String, price: Double, quantity: Int) {
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}

struct ShoppingCart : CustomStringConvertible
{
    var cartItems: [CartItem] = []
    
    var description: String {
        return cartItems.description
    }
    
    
}
