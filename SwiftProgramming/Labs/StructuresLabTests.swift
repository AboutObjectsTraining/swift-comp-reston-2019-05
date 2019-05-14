//
// Copyright (C) 2016 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
import XCTest

class StructuresLabTests: XCTestCase
{
    // Instructions: Define `CartItem` struct
    func testLineItem() {
        let item = CartItem(name: "tees", price: 34.95, quantity: 6)
        print(item)
    }
    
    // Instructions: Add `discount` property
    func testLineItemDiscounts() {
        for item in cartItems {
            print(item.discount)
        }
    }
    
    // Instructions:
    // 1. Add `discountAmount` property
    // 2. Add `onSale` property
    // 3. Add custom initializer
    func testDiscountedLineItems() {
        var items = cartItems
        items[0].onSale = true
        items[1].onSale = true
        for item in items {
            print("amount: \(item.amount), discount: \(item.discountAmount)")
        }
    }
    
    func testShoppingCart() {
        var cart = ShoppingCart(cartItems: cartItems)
        cart.cartItems[0].onSale = true
        cart.cartItems[0].onSale = true
        print(cart)
    }
}
