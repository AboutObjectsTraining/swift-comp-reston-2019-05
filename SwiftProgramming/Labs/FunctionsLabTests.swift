// Copyright (C) 2015 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this example's licensing information.
//
import XCTest

let fahrenheitValues: [Double] = [-10, 0, 10, 32, 72, 100]
let format = "\n%5.1f°F equals %5.1f°C "

func convertedToCelsius(fahrenheit: Double) -> Double
{
    return (fahrenheit - 32) * (5/9)
}


class FunctionsLabTests: XCTestCase
{
    func testConvertFahrenheitToCelsiusUsingForLoop()
    {
        for value in fahrenheitValues {
            let celsius = convertedToCelsius(fahrenheit: value)
            let formattedValue = String(format: "%.1f", celsius)
            print("\(value)°F equals \(formattedValue)°C")
        }
    }
    
    func testConvertFahrenheitToCelsiusUsingMap()
    {
        let celsiusValues = fahrenheitValues.map { convertedToCelsius(fahrenheit: $0) }
        print(celsiusValues)
        
        let formattedValues = celsiusValues.map { String(format: "%.1f", $0) }
        print(formattedValues)
    }
    
    func testConvertFahrenheitToCelsiusUsingMapReduce1()
    {
        let formattedValues = fahrenheitValues.map {
            String(format: format, $0, convertedToCelsius(fahrenheit: $0))
        }
        let text = formattedValues.reduce("") { $0 + $1 }
        print(text)
    }

    
    func testConvertFahrenheitToCelsiusUsingMapReduce2()
    {
        print(fahrenheitValues
            .map { String(format: format, $0, convertedToCelsius(fahrenheit: $0)) }
            .reduce("",  +))
    }
    
    func testConvertFahrenheitToCelsiusUsingTuples()
    {
        let tuples = fahrenheitValues.map { (F: $0, C: convertedToCelsius(fahrenheit: $0)) }
        
        let text = tuples.reduce("") {
            $0 + String(format: format, $1.F, $1.C)
        }
        print(text)
    }
}


