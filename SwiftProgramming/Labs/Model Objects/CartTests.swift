//
// Copyright (C) 2016 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
import XCTest

let myItems = [
    Cart.Item(name: "jeans", price: 49.99, quantity: 3, onSale: true),
    Cart.Item(name: "tees", price: 29.99, quantity: 4, onSale: false),
    Cart.Item(name: "polos", price: 44.95, quantity: 5, onSale: true),
    Cart.Item(name: "socks", price: 6.99, quantity: 6, onSale: false),
]

let myCart = Cart(items: myItems)

class CartTests: XCTestCase
{
    func testInitializeCartItem() {
        let item1 = Cart.Item(name: "jeans", price: 49.99, quantity: 3)
        print(item1)
        let item2 = Cart.Item(name: "tees", price: 29.99, quantity: 4, onSale: true)
        print(item2)
    }
    
    func testAddItemsToCart() {
        let cart = Cart()
        cart.add(item: Cart.Item(name: "jeans", price: 49.99, quantity: 2))
        cart.add(item: Cart.Item(name: "tees", price: 29.99, quantity: 3))
        print(cart)
    }
    func testCartAmount() {
        print(myCart.amount)
        print(myCart.discountAmount)
        print("discounted amount: \(myCart.amount - myCart.discountAmount)")
    }
}
