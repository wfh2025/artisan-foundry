extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
let oneKm = 1.km
print("line: \(#line)", "\(oneKm.m)")

struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
}
let defaultRect = Rect()
let memberwiseRect = Rect(
    origin: Point(x: 2.0, y: 2.0), size: Size(width: 5.0, height: 5.0))
print("line: \(#line)", "\(memberwiseRect)")

extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

let centerRect = Rect(
    center: Point(x: 4.0, y: 4.0), size: Size(width: 3.0, height: 3.0))
print("line: \(#line)", "\(centerRect)")

extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}

let m: Int = 2

func callBackOfInt() {
    print("line: \(#line)", "ha")
}
m.repetitions(task: callBackOfInt)
3.repetitions {
    print("line: \(#line)", "zha")
}

extension Int {
    mutating func square() {
        self = self * self
    }
}
var someInt = 3
print("line: \(#line)", "\(someInt.square())", "\(someInt)")

extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}
print(
    "line: \(#line)",
    "\(746_381_295[8])", "\(746_381_295[7])",
    "\(746_381_295[6])", "\(746_381_295[5])",
    "\(746_381_295[4])", "\(746_381_295[3])",
    "\(746_381_295[2])", "\(746_381_295[1])",
    "\(746_381_295[0])")

extension Int {
    enum Kind {
        case negative, zero, positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}

func printIntegerKinds(_ numbers: [Int]) {
    for number in numbers {
        switch number.kind {
        case .negative:
            print("line: \(#line)", "- ")
        case .zero:
            print("line: \(#line)", "0 ")
        case .positive:
            print("line: \(#line)", "+ ")
        }
    }

}
printIntegerKinds([3, 19, -27, 0, -6, 0, 7])
