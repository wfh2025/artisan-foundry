import Foundation

struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}
var square = Rect(
    origin: Point(x: 0.0, y: 0.0),
    size: Size(width: 10.0, height: 10.0))
print("line: \(#line)", "\(square.center)")

square.center = Point(x: 15.0, y: 15.0)
print(
    "line: \(#line)", "\(square.origin.x)", "\(square.origin.y)"
)

struct AlternativeRect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set {
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}

var r = AlternativeRect(
    origin: Point(x: 0.0, y: 0.0),
    size: Size(width: 10.0, height: 10.0)
)

r.center = Point(x: 15.0, y: 18.0)
print(
    "line: \(#line)", "\(r.origin.x)", "\(r.origin.y)"
)

struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double {
        return width * height * depth
    }
}
let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
print(
    "line: \(#line)", "\(fourByFiveByTwo.volume)"
)

class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print(
                "line: \(#line)", "new: \(newTotalSteps)"
            )
        }
        didSet {
            if totalSteps > oldValue {
                print(
                    "line: \(#line)", "current: \(totalSteps)",
                    "old: \(oldValue)"
                )
            }
        }
    }
}
let stepCounter = StepCounter()
stepCounter.totalSteps = 200
stepCounter.totalSteps = 360
stepCounter.totalSteps = 896

@propertyWrapper
struct TwelveOrLess {
    private var number = 0
    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, 12) }
    }
}

struct SmallRectangle {
    @TwelveOrLess var height: Int
    @TwelveOrLess var width: Int
}

struct SmallRectangle2 {
    private var _height = TwelveOrLess()
    private var _width = TwelveOrLess()
    var height: Int {
        get { return _height.wrappedValue }
        set { _height.wrappedValue = newValue }
    }
    var width: Int {
        get { return _width.wrappedValue }
        set { _width.wrappedValue = newValue }
    }
}

var rectangle = SmallRectangle()
print("line: \(#line)", "new: \(rectangle.height)")

rectangle.height = 10
print("line: \(#line)", "new: \(rectangle.height)")

rectangle.height = 24
print("line: \(#line)", "new: \(rectangle.height)")

@propertyWrapper
struct SmallNumber {
    private var maximum: Int
    private var number: Int

    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, maximum) }
    }

    init() {
        maximum = 12
        number = 0
    }
    init(wrappedValue: Int) {
        maximum = 12
        number = min(wrappedValue, maximum)
    }
    init(wrappedValue: Int, maximum: Int) {
        self.maximum = maximum
        number = min(wrappedValue, maximum)
    }
}

struct ZeroRectangle {
    @SmallNumber var height: Int
    @SmallNumber var width: Int
}

var zeroRectangle = ZeroRectangle()
print("line: \(#line)", "\(zeroRectangle.height)", "\(zeroRectangle.width)")

struct UnitRectangle {
    @SmallNumber var height: Int = 1
    @SmallNumber var width: Int = 1
}

var unitRectangle = UnitRectangle()
print("line: \(#line)", "\(unitRectangle.height)", "\(unitRectangle.width)")

struct NarrowRectangle {
    @SmallNumber(wrappedValue: 2, maximum: 5) var height: Int
    @SmallNumber(wrappedValue: 3, maximum: 4) var width: Int
}

var narrowRectangle = NarrowRectangle()
print("line: \(#line)", "\(narrowRectangle.height)", "\(narrowRectangle.width)")

narrowRectangle.height = 100
narrowRectangle.width = 100
print("line: \(#line)", "\(narrowRectangle.height)", "\(narrowRectangle.width)")

struct MixedRectangle {
    @SmallNumber var height: Int = 1
    @SmallNumber(maximum: 9) var width: Int = 2
}

var mixedRectangle = MixedRectangle()
print("line: \(#line)", "\(mixedRectangle.height)")

mixedRectangle.height = 20
print("line: \(#line)", "\(mixedRectangle.height)")

@propertyWrapper
struct SmallNumber2 {
    private var number: Int
    private(set) var projectedValue: Bool

    var wrappedValue: Int {
        get { return number }
        set {
            if newValue > 12 {
                number = 12
                projectedValue = true
            } else {
                number = newValue
                projectedValue = false
            }
        }
    }

    init() {
        self.number = 0
        self.projectedValue = false
    }
}
struct SomeStructure {
    @SmallNumber2 var someNumber: Int
}
var someStructure = SomeStructure()

someStructure.someNumber = 4
print(someStructure.$someNumber)
print("line: \(#line)", "\(someStructure.$someNumber)")

someStructure.someNumber = 55
print("line: \(#line)", "\(someStructure.$someNumber)")
