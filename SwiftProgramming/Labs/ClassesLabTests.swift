// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
import XCTest

// Note: we need to specify the array type here because otherwise the
// Swift runtime doesn't see the type [Persons] as a match for [Friendable].
//
let persons = [
    Person("Fred", "Smith", 101),
    Person("Jan", "Wood", 102),
    Person("Bill", "Jones", 103),
    Person("Bob", "Hill", 104),
    Person("Dee", "Smith", 105),
    Person("Jean", "Hill", 106),
    Person("Dick", "Gray", 107),
    Person("Jill", "Ross", 108),
]

func ==(lhs: Friendable, rhs: Friendable) -> Bool
{
    return lhs.friendID == rhs.friendID
}

func !=(lhs: Friendable, rhs: Friendable) -> Bool
{
    return lhs.friendID != rhs.friendID
}

class ClassesLabTests: XCTestCase
{
    func testLikes() {
        let fred: Person = persons[0]
        fred.like()
        print(fred)
        fred.like()
        print(fred)
        fred.unlike()
        print(fred)
        fred.unlike()
        print(fred)
        fred.unlike()
        print(fred)
    }
    
    func testFilter()
    {
        let oldFriend = persons[5]
        let filteredPeople = persons.filter { (currPerson) -> Bool in
            currPerson.friendID == oldFriend.friendID
        }
        print(filteredPeople)
    }
    
    func testUnfriend() {
        let fred = Person(firstName: "Fred", lastName: "Smith")
        
        for currFriend in persons {
            fred.friend(currFriend)
        }
        
        print(fred.friends)
        print(fred.friends.count)
        
        fred.unfriend(fred.friends[2])
        
        print(fred.friends)
        print(fred.friends.count)
    }
    
    func testEquatable() {
        let p1 = Person("Fred", "Smith", 100)
        let p2 = Person("Fred", "Smith", 100)
        let p3 = Person("Fred", "Smith", 99)
        
        print("p1 == p1 is \(p1 == p1)")
        print("p1 == p2 is \(p1 == p2)")
        print("p1 == p3 is \(p1 == p3)")

        print("p1 === p1 is \(p1 === p1)")
        print("p1 === p2 is \(p1 === p2)")
        
        print("p1 != p1 is \(p1 != p2)")
        print("p1 != p2 is \(p1 != p3)")
    }
    
    func testNumbers() {
        let x = 42
        let y: Float = Float(x)
        // let z: Float = x     // Illegal
        print(y)
    }
    
    func testCoolness() {
        let p1 = Person(firstName: "Fred", lastName: "Smith")
        print("isCool == \(p1.isCool)")
        let p2: Likeable = Person(firstName: "Fred", lastName: "Smith")
        print("isCool == \(p2.isCool)")
    }
}
