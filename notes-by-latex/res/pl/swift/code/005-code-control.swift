import Foundation

let names = ["Anna", "Alex", "Brian", "Jack"]
for name in names {
    print(
        "line:", "\(#line)",
        "info:", "\(name)"
    )
}

let numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
for (key, value) in numberOfLegs {
    print(
        "line:", "\(#line)", "info:", "\(key)", "\(value)"
    )
}

for index in 1...3 {
    print(
        "line:", "\(#line)", "info:", "\(index)"
    )
}

for index in 1..<3 {
    print(
        "line:", "\(#line)", "info:", "\(index)"
    )
}

for _ in 1...3 {
    print(
        "line:", "\(#line)", "info:", "no index"
    )
}

for x in stride(from: 0, to: 15, by: 5) {
    print(
        "line:", "\(#line)", "info:", "\(x)"
    )
}

for x in stride(from: 0, through: 15, by: 5) {
    print(
        "line:", "\(#line)", "info:", "\(x)"
    )
}

let someCharacter: Character = "z"
switch someCharacter {
case "a":
    print(
        "line:", "\(#line)", "info:", "a"
    )
case "z":
    print(
        "line:", "\(#line)", "info:", "z"
    )
default:
    print(
        "line:", "\(#line)", "info:", "default"
    )
}

let anotherCharacter: Character = "A"
switch anotherCharacter {
case "a", "A":
    print(
        "line:", "\(#line)", "info:", "a"
    )
default:
    print(
        "line:", "\(#line)", "info:", "default"
    )
}

let approximateCount = 62
let naturalCount: String
switch approximateCount {
case 0:
    naturalCount = "no"
case 1..<5:
    naturalCount = "a few"
case 5..<12:
    naturalCount = "several"
case 12..<100:
    naturalCount = "dozens of"
case 100..<1000:
    naturalCount = "hundreds of"
default:
    naturalCount = "many"
}
print(
    "line:", "\(#line)",
    "info:", "\(naturalCount)"
)

let somePoint = (1, 1)
switch somePoint {
case (0, 0):
    print("line:", "\(#line)")
case (_, 0):
    print("line:", "\(#line)")
case (0, _):
    print("line:", "\(#line)")
case (-2...2, -2...2):
    print("line:", "\(#line)")
default:
    print("line:", "\(#line)")
}

let anotherPoint = (2, 0)
switch anotherPoint {
case (let x, 0):
    print("line:", "\(#line)", "info:", "\(x)")
case (0, let y):
    print("line:", "\(#line)", "info:", "\(y)")
case let (x, y):
    print("line:", "\(#line)", "info:", "\(x)", "\(y)")
}

let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y:
    print("line:", "\(#line)", "info:", "\(x)", "\(y)")
case let (x, y) where x == -y:
    print("line:", "\(#line)", "info:", "\(x)", "\(y)")
case let (x, y):
    print("line:", "\(#line)", "info:", "\(x)", "\(y)")
}

let stillAnotherPoint = (9, 0)
switch stillAnotherPoint {
case (let distance, 0), (0, let distance):
    print("line:", "\(#line)", "info:", "\(distance)")
default:
    print("line:", "\(#line)")
}

let puzzleInput = "great minds think alike"
var puzzleOutput = ""
for character in puzzleInput {
    switch character {
    case "a", "e", "i", "o", "u", " ":
        continue
    default:
        puzzleOutput.append(character)
    }
}
print("line:", "\(#line)", "info:", "\(puzzleOutput)")

let numberSymbol: Character = "9"
var possibleIntegerValue: Int?
switch numberSymbol {
case "一":
    possibleIntegerValue = 1
case "二":
    possibleIntegerValue = 2
case "三":
    possibleIntegerValue = 3
case "四":
    possibleIntegerValue = 4
default:
    break
}
if let integerValue = possibleIntegerValue {
    print("line:", "\(#line)", "info:", "\(numberSymbol)", "\(integerValue)")
    print("The integer value of \(numberSymbol) is \(integerValue).")
} else {
    print("line:", "\(#line)", "info:", "\(numberSymbol)")
}

let integerToDescribe = 5
switch integerToDescribe {
case 2, 3, 5, 7, 11, 13, 17, 19:
    print("line:", "\(#line)")
    fallthrough
default:
    print("line:", "\(#line)")
}
func greet(person: [String: String]) {
    guard let name = person["name"] else {
        return
    }

    print("line:", "\(#line)", "info:", "\(name)")

    guard let location = person["location"] else {
        print("line:", "\(#line)", "info:", "no location")
        return
    }

    print("line:", "\(#line)", "info:", "\(location)")
}

greet(person: ["name": "John"])
greet(person: ["name": "Jane", "location": "Cupertino"])
