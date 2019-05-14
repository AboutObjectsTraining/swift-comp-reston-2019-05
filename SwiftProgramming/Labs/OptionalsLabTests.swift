//
// Copyright (C) 2016 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
import XCTest

let address1 = Address(street: "12 Pine St.", city: "Reston", state: "VA")
let address2 = Address(street: "3 Elm St.", street2: "Apt 2C", city: "Reston", state: "VA")


var customers = [
    Customer(name: "Sue Yu", address: nil),
    Customer(name: "Anna Graham", address: address2)
]

class OptionalsLabTests: XCTestCase
{
    func testFullStreet() {
        print(address1.fullStreet)
        print(address2.fullStreet)
    }
    
    func testInitializeCustomer() {
        let customer = Customer()
        print(customer)
        
        customer.name = "Fred Smith"
        print(customer)
        
        customer.address = address1
        print(customer)
    }
    
    func testCustomerNamed() {
        let customer = customers.customer(named: "Anna Graham")
        print(customer ?? "not found")
    }
}

