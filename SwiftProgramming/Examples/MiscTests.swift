import XCTest

@testable import SwiftProgramming


enum MathError: Error {
    case zeroDivide
    case overflow
}

extension Double
{
    func divided(by denominator: Double) throws -> Double {
        if denominator == 0.0 {
            throw MathError.zeroDivide
        }
        return self / denominator
    }
}

func foo(x: Int, y: Int) -> Int {
    return x*x + y*y
}

class MiscTests: XCTestCase
{
    override func setUp()    { super.setUp(); print("") }
    override func tearDown() { print(""); super.setUp() }
    
    func testCallingConventions() {
        // A function's full name can precede a call's argument list
        let x = foo(x: y:)(3, 5)
        print(x)
    }
    
    func testGuardScope() {
        for i in 1...5 {
            guard i % 2 == 0 else { continue }
            print(i)
        }
    }
    
    func testStrings()
    {
        let emojiText = "Hello World! 😊 🌍 "
        print(emojiText.count)
        
        let text = "Hello World!"
        print(text.isEmpty)                // prints false
        print(text.uppercased())
        print(text.hasPrefix("Hello"))
        
        let foundationEmojiText: NSString = emojiText as NSString
        print(foundationEmojiText.length)  // returns 17
        
        let fruits = ["Apple", "Pear", "Banana"]
        let fruitText = fruits.joined(separator: ", ")
        print(fruitText)
        
//        fruitText.write(toFile: "/tmp/fruit", atomically: true, encoding: .utf8)
//        String(contentsOfFile: <#T##String#>)
        
        let elements = fruitText.components(separatedBy: ", ")
        print(elements)
    }
    
    func testCatch()
    {
        do {
            let result1 = try 42.divided(by: 2)
            print("result 1 is \(result1)")
            
            let result2 = try result1.divided(by: 3)
            print("result 2 is \(result2)")
        }
        catch MathError.zeroDivide {
            print("Zero divide")
        }
        catch MathError.overflow {
            print("Overflow")
        }
        catch {
            print ("Unexpected error")
        }
        
        
        var words: [Any] = ["Hello", "World"]
        let word = words[0] as! String     // forced downcast
        print(word)
        
        words[0] = 1
//        print(words[0] as! String)        // asplode
    
        let things: [Any?] = [1, "World"]
        if let foo = things[0] as? Int {
            print(foo)
        }
        
        let objects: [Any] = [42, "Fred", 3.5]
        for object in objects {
            switch (object) {
            case let value as Int:
                print("The answer is \(value / 6)")
            case let value as String:
                print("Hi \(value), have a nice day!")
            case let value as Double:
                print("It's \(value)°F? Brr, that's cold.")
            default:
                print("The object is \(object)")
            }
        }

    }

    func testOptionals()
    {
        let wrappedText: Optional<String> = Optional.some("lol")
        
        // Unwrap using enumeration case pattern
        if case .some(let text) = wrappedText {
            print(text.uppercased())
        }
        // Prints "LOL"
        
        // Int initializer returns optional because conversion can fail
        let wrappedX: Optional<Int> = Int("12")
        
        if case let .some(x) = wrappedX {
            print("x squared is \(x * x)")
        }
        else {
            print("x is null")
        }
    }
    
    func testOptionalsShorthand()
    {
        let wrappedText: String? = "lol"
        
        if case let text? = wrappedText {
            print(text.uppercased())
        }
        
        // Unwrap using optional pattern
        if let text = wrappedText {
            print(text.uppercased())
        }
        
        
        let wrappedX = Int("12")
        
        if let x = wrappedX {
            print("x squared is \(x * x)")
        }
        else {
            print("x is null")
        }
        
//        var lastName: String! = "Smith"
//        let lastName: String! = nil
//        print("Fred " + lastName)
        
//        lastName = nil
//        print("Fred " + lastName)
        
        let x = try! 12.divided(by: 1.25)
        print(x)
        
//        let xxx = try! 12.divided(by: 0)
//        print(xxx)
        
        guard let y = try? 12.divided(by: 1.5) else {
            return
        }
        print(y)
        
        guard let yyy = try? 12.divided(by: 0) else {
            return
        }
        print(yyy)
    }
    
//    func divided(numerator: Double, denominator: Double) throws -> Double {
//        if denominator == 0.0 {
//            throw MathError.zeroDivide
//        }
//        return numerator / denominator
//    }
    
    func testSquared() {
        if let s = squared(numericString: "12") {
            print(s)
        }
        if let s = squared(numericString: "abc") {
            print(s)
        }
    }
    
    func squared(numericString: String) -> String?
    {
        guard let value = Double(numericString) else { return nil }
        let square = value * value
        return square.description
    }
    
    
    func testOptionalPattern()
    {
        let wrappedWords: [String?] = [nil, "Apple", nil, "Orange"]
        
        // print non-nil values
        for word in wrappedWords {
            if let unwrappedWord = word {
                print(unwrappedWord)
            }
        }
        
        // conditionally unwrap in test expression
        for case .some(let word) in wrappedWords {
            print(word)
        }
        
        // streamlined conditional unwrapping
        for case let word? in wrappedWords {
            print(word)
        }
    }
    
    func testOptionalMap() {
        let s1 = Optional.some("hello")
        let s2 = s1.map { $0.capitalized }
        print(s2 ?? "N/A")
    }
    
    func testFlatMap() {
        let a1 = [[1, 2], [3, 4], [5, 6]]
        let a1Flattened = a1.flatMap { $0 }
        print(a1Flattened)
        // [1, 2, 3, 4, 5, 6]
        
        let a2: [Int?] = [1, nil, 2]
        let a2Flattened = a2.compactMap { $0 }
        print(a2Flattened)
        // [1, 2]

        let a3: [[Int]?] = [[1, 2], nil, [3, 4], [5, 6]]
        let a3Flattened = a3.compactMap { $0 }
        print(a3Flattened)
        // [[1, 2], [3, 4], [5, 6]]
        
        let a4: [[Int]?] = [[1, 2], nil, [3, 4], [5, 6]]
        let a4Flattened = a4
            .compactMap { $0 }
            .flatMap { $0 }
        print(a4Flattened)
        // [1, 2, 3, 4, 5, 6]

        let a5 = [[[1, 2], [3, 4]], [[5, 6]]]
        let a5Flattened = a5.flatMap { $0 }
        print(a5Flattened)
        // [[1, 2], [3, 4], [5, 6]]

    }
    
    func testClosures() {
        let favoriteColor = "Green"
        let colors = ["Red", "Orange", "Yellow",
                      "Green", "Blue", "Indigo", "Violet"]
        
//        let i = colors.index(after: 0)
//        colors.index(where: <#T##(String) throws -> Bool#>)
        
        let index = colors.firstIndex { $0 == favoriteColor }
        print(index ?? -1)
    }
    
    func testMapReduce() {
        let range = 1...5
        let factorial = range.reduce(1, *)
        print(factorial)
        // 120
    }
    
    func testRange()
    {
//        let range1 = Range(uncheckedBounds: (lower: 0, upper: 2))
//        let range2 = ClosedRange(uncheckedBounds: (lower: 0, upper: 2))
//        let range3 = 0..<2 
        
        let colors = ["Red", "Orange", "Yellow",
                      "Green", "Blue", "Indigo", "Violet"]
        
        let coolIndex = colors.firstIndex(of: "Green") ?? colors.endIndex
        let warmRange = 0..<coolIndex
        print(warmRange)
        
        let coolRange = coolIndex..<colors.endIndex
        print(coolRange)
        print(coolRange.upperBound)
        print(coolRange.overlaps(warmRange))
        print(coolRange.first ?? -1)
        
        for (index, value) in coolRange.enumerated() {
            print("\(index): \(value)")
        }
        
        print(colors[coolRange])
        print(colors[warmRange])
        
        let doubleRange = 0.0...1.0
        print(doubleRange.contains(0.5))
        print(doubleRange ~= 0.5)
        
        let allColorsRange = [warmRange, coolRange].joined()
        for index in allColorsRange {
            print(index, terminator: ", ")
        }
        print()
        
        print(colors[0..<3])
        print(colors[3..<colors.endIndex])
//        let range3 = ClosedCountedRange<Int>
    }
    
    func testIfCase()
    {
        let supplies = [("pens", 1.75), ("pads", 1.25), ("glue", 2.50)]
        let item = supplies[1]
        
        if case let (name, price) = item, price < 2 {
            print("\(name): $\(price)")
        }
        
        for case let (name, price) in supplies where price < 2 {
            print("\(name): $\(price)")
        }
        
        for (name, price) in supplies where price < 2 {
            print("\(name): $\(price)")
        }
    }
    
    func testArray()
    {
        var words = ["one", "two", "three"]
        print(words[1])
        // "two"
        
        words[0] = "uno"
        print(words)
        // ["uno", "two", "three"]
        
        print(words.count)
        // 3
        
        print(words.last ?? "")
        // "three"
        
        words.insert("ONE", at: 0)
        print(words)
        // ["ONE", "uno", "two", "three"]
        
        words.remove(at: 1)
        print(words)
        // ["ONE", "two", "three"]
        
        words.append("four")
        print(words)
        // ["ONE", "two", "three", "four"]
        
        words.append(contentsOf: ["five", "six"])
        print(words)
        // ["ONE", "two", "three", "four", "five", "six"]

        let words2 = words + ["seven"]
        print(words2)
        // ["ONE", "two", "three", "four", "five", "six", "seven"]
        
//        words.sort()
//        print(words)
//        // ["ONE", "five", "four", "six", "three", "two"]
        
        print(words.joined(separator: ", "))
        // ONE, two, three, four, five, six
        
        print(words.sorted())
        // ["ONE", "five", "four", "six", "three", "two"]
        
        let colors1 = ["red", "green", "blue"]
        var colors2 = colors1
//        colors1[0] = "pink"
        print(colors1)
        
        colors2[0] = "pink"
        print(colors2)
}
    
    func testCreateDog()
    {
        let rover = Dog()
        rover.isPet = true;
        rover.name = "Rover"
        rover.barkText = "Bow, wow!"
        
        print(rover.description())
        
        print("Address is \(Unmanaged.passUnretained(rover).toOpaque()) ")
        
        print(rover.numberOfLegs)
    }

    var path: String { return Bundle(for: type(of: self)).path(forResource: "Info", ofType: ".plist")! }
    
    func testFileHandle()
    {
        do {
            try showFile(atPath: path)
        }
        catch FileError.nonexistent(let message) { // unwraps associated value
            print(message)
        }
        catch is FileError {
            print("Some other file error occurred.")
        }
        catch {
            print("Unexpected error.")
        }
        
        print("End of test")
    }
    
    func testMatchingPhones() {
        let contact = ContactInfo()
        
        // Calling method with trailing closure
        let phonesMatchingAreaCodes = contact.phones() { key, value in
            value.hasPrefix("914")
        }
        print(phonesMatchingAreaCodes)
        // produces ["other:": "914-456-7890", "mobile": "914-789-1234"]

        // When the only param is a trailing closure, parameter list can be ommitted entirely
        let daytimePhones = contact.phones { key, value in
            key == "work" || key == "mobile"
        }
        print(daytimePhones)
        // produces ["mobile": "914-789-1234", "work": "516-456-7890"]
        
        
        let areaCode = "914"
        
        let phonesMatchingCapturedValue = contact.phones { key, value in
            value.hasPrefix(areaCode)
        }
        
        print(phonesMatchingCapturedValue)
        // produces ["other:": "914-456-7890", "mobile": "914-789-1234"]
        
        let daytimePhonesWithCapturedValue = contact.phones { [unowned self] key, value in
            self.daytimeKeys.contains(key)
        }
        print(daytimePhonesWithCapturedValue)
        // produces ["mobile": "914-789-1234", "work": "516-456-7890"]
    }
    
    var daytimeKeys = Set(["work", "mobile"])
}

struct ContactInfo {
    let phones = [
        "home": "202-123-4567",
        "work": "516-456-7890",
        "mobile": "914-789-1234",
        "other:": "914-456-7890"
    ]
    
    // method with single argument of type closure
    func phones(matching: (String, String) -> Bool) -> [String: String] {
        var matchedPhones = [String: String]()
        for (key, value) in phones {
            if matching(key, value) {
                matchedPhones[key] = value
            }
        }
        return matchedPhones
    }
}

enum FileError: Error {
    case unknown
    case nonexistent(String) // Note: associated value
}

func showFile(atPath path: String) throws {
    guard let fileHandle = FileHandle(forReadingAtPath: path) else {
        // throws error with associated value
        throw FileError.nonexistent("No file at path \(path)")
    }
    
    defer {
        fileHandle.closeFile()
        print("Closed fileHandle \(fileHandle)")
    }
    
    let data = fileHandle.readDataToEndOfFile()
    FileHandle.standardOutput.write(data)
}

