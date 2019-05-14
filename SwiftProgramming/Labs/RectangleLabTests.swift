import XCTest

private let myRect = Rectangle(origin: Point(x: 5.0, y: 5.0),
                               size: Size(width: 40.0, height: 20.0))

class RectangleLabTests: XCTestCase
{
    override func setUp()    { super.setUp(); print() }
    override func tearDown() { print(); super.tearDown() }

    func testArea()
    {
        print(myRect)
        let expectedValue = myRect.width * myRect.height
        XCTAssertEqual(expectedValue, myRect.area, "Area should equal width times height.")
    }
    
    func testCenterProperty()
    {
        let expectedValue = Point(x: (myRect.x + myRect.width) / 2.0,
                                  y: (myRect.y + myRect.height) / 2.0)
        XCTAssert(myRect.center.x == expectedValue.x && myRect.center.y == expectedValue.y)
        print("myRect  = \(myRect)" + "\nnewRect = \(expectedValue)")
    }
    
    func testOffset()
    {
        let newRect = myRect.offsetBy(dx: 7.5, dy: 12.5)
        let expectedValue = Point(x: myRect.x + 7.5, y: myRect.y + 12.5)
        XCTAssert(expectedValue.x == myRect.x + 7.5 && expectedValue.y == myRect.y + 12.5)
        print("myRect  = \(myRect)" + "\nnewRect = \(newRect)")
    }
}
