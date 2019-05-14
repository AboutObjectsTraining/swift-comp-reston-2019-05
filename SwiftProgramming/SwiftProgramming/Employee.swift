// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//

class Employee: Person
{
    let employeeID: Int
    var salary: Double
    var title: String = "Unknown"
    // var manager: Employee       // Problematic!
    
    init(firstName: String, lastName: String, employeeID: Int, salary: Double)
    {
        self.employeeID = employeeID
        self.salary = salary
        super.init(firstName: firstName, lastName: lastName)
    }
}