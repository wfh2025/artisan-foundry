import Foundation

enum CompassPoint: Int, CaseIterable {
    case north = 1
    case south
    case east
    case west
}

var d: CompassPoint = CompassPoint.east
d = .north
switch d {
case .north:
    print("line: \(#line), directino: north")
case .south:
    print("line: \(#line), directino: south")
case .east:
    print("line: \(#line), directino: east")
case .west:
    print("line: \(#line), directino: west")
}

let numOfItems = CompassPoint.allCases.count
print("enum item num: \(numOfItems)")

for e in CompassPoint.allCases {
    print("line: \(#line), elem: \(e)")
}

enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

var prodCode = Barcode.upc(8, 85909, 51226, 3)
prodCode = .qrCode("ABCDEFGHIJKPMNOP")

switch prodCode {
case .upc(let numSys, let manufacturer, let prod, let check):
    print(
        "line: \(#line), parms: \(numSys), \(manufacturer), \(prod), \(check)")
case .qrCode(let productCode):
    print("line: \(#line), parms: \(productCode)")
}

switch prodCode {
case let .upc(numSys, manufacturer, prod, check):
    print(
        "line: \(#line), parms: \(numSys), \(manufacturer), \(prod), \(check)")
case let .qrCode(productCode):
    print("line: \(#line), parms: \(productCode)")
}

let dirCode = CompassPoint.south.rawValue
print("line: \(#line), raw: \(dirCode)")

let possibleDirection = CompassPoint(rawValue: 20)
print("line: \(#line), type: \(type(of: possibleDirection))")
if let dir = possibleDirection {
    print("line: \(#line), params: \(dir)")
} else {
    print("line: \(#line), invalid direction")
}

enum ArithmeticExpression {
    case number(Int)
    indirect case add(ArithmeticExpression, ArithmeticExpression)
    indirect case multi(ArithmeticExpression, ArithmeticExpression)
}

func evaluate(_ exp: ArithmeticExpression) -> Int {
    switch exp {
    case let .number(value):
        return value
    case let .add(left, right):
        return evaluate(left) + evaluate(right)
    case let .multi(left, right):
        return evaluate(left) * evaluate(right)
    }
}

let product = ArithmeticExpression.multi(
    ArithmeticExpression.add(
        ArithmeticExpression.number(5), ArithmeticExpression.number(4)),
    ArithmeticExpression.number(2))
print("line: \(#line), product: \(evaluate(product))")
