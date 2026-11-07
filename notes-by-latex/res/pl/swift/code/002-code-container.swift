import Foundation

var arr: [Int] = []
print("line: \(#line), params: \(arr.count)")

arr.append(3)
print("line: \(#line), params: \(arr.count)")

arr = []
print("line: \(#line), params: \(arr.count)")

arr = Array(repeating: 2, count: 3)
print("line: \(#line), params: \(arr)")

arr = Array(repeating: 2, count: 3) + Array(repeating: 1, count: 2)
print("line: \(#line), params: \(arr)")

var shoppingList = ["Eggs", "Milk"]
if shoppingList.isEmpty {
    print("line: \(#line), params: \(shoppingList.isEmpty)")
} else {
    print("line: \(#line), params: \(shoppingList.isEmpty)")
}

for item in shoppingList {
    print("line: \(#line), params: \(item)")
}

for (idx, value) in shoppingList.enumerated() {
    print("line: \(#line), idx: \(idx), value: \(value)")
}

shoppingList += ["Baking Powder", "Chocolate Spread", "Cheese", "Butter"]
print("line: \(#line), params: \(shoppingList), \(shoppingList[0])")

shoppingList[0] = "xxx"
print("line: \(#line), params: \(shoppingList), \(shoppingList[0])")

shoppingList[2...4] = ["Bananas", "Apples"]
print("line: \(#line), params: \(shoppingList)")

shoppingList.insert("Maple Syrup", at: 0)
print("line: \(#line), params: \(shoppingList)")

var tmp = shoppingList.remove(at: 0)
print("line: \(#line), params: \(shoppingList), \(tmp)")

tmp = shoppingList.removeLast()
print("line: \(#line), params: \(shoppingList), \(tmp)")

var letters = Set<Character>()
print("line: \(#line), params: \(letters)")

var favorite: Set<String> = ["Rock", "Hip"]
print("line: \(#line), params: \(favorite)")

favorite.insert("Jazz")
if favorite.isEmpty {
    print("line: \(#line), params: \(favorite.isEmpty)")
} else {
    print("line: \(#line), params: \(favorite.count)")
}

if let removedGenre = favorite.remove("Rock") {
    print("line: \(#line), params: \(removedGenre)")
} else {
    print("line: \(#line), xxx")
}

if favorite.contains("Funk") {
    print("line: \(#line), contains")
} else {
    print("line: \(#line), not contains")
}

for genre in favorite {
    print("line: \(#line), params: \(genre)")
}

for genre in favorite.sorted() {
    print("line: \(#line), params: \(genre)")
}

let oddDigits: Set = [1, 3, 5, 7, 9]
let evenDigits: Set = [0, 2, 4, 6, 8]
let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]

print("line: \(#line), params: \(oddDigits.union(evenDigits).sorted())")
print("line: \(#line), params: \(oddDigits.intersection(evenDigits).sorted())")
print(
    "line: \(#line), params: \(oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted())"
)
print(
    "line: \(#line), params: \(oddDigits.subtracting(singleDigitPrimeNumbers).sorted())"
)

let houseAnimals: Set = ["A", "B"]
let farmAnimals: Set = ["C", "D", "E", "A", "B"]
let cityAnimals: Set = ["F", "G"]
print("line: \(#line), params: \(houseAnimals.isSubset(of: farmAnimals))")
print("line: \(#line), params: \(farmAnimals.isSuperset(of: houseAnimals))")
print("line: \(#line), params: \(farmAnimals.isDisjoint(with: cityAnimals))")

var namesOfIntegers: [Int: String] = [:]
namesOfIntegers[16] = "sixteen"
print("line: \(#line), params: \(namesOfIntegers)")
namesOfIntegers = [:]
print("line: \(#line), params: \(namesOfIntegers)")

var airports: [String: String] = [
    "YYZ": "Toronto Pearson",
    "DUB": "Dublin",
]

for (airportCode, airportName) in airports {
    print("line: \(#line), \(airportCode), \(airportName)")
}

for airportCode in airports.keys {
    print("line: \(#line), \(airportCode)")
}

for airportName in airports.values {
    print("line: \(#line), \(airportName)")
}

if airports.isEmpty {
    print("line: \(#line), params: \(airports.isEmpty)")
} else {
    print("line: \(#line), params: \(airports.count)")
}
print("line: \(#line), params: \(airports)")

if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
    print("line: \(#line), params: \(oldValue), \(airports)")
}

if let airportName = airports["DUB"] {
    print("line: \(#line), params: \(airportName)")
} else {
    print("line: \(#line)")
}

airports["DUB"] = nil
print("line: \(#line), params: \(airports)")

if let removedValue = airports.removeValue(forKey: "YYZ") {
    print("line: \(#line), params: \(removedValue)")
} else {
    print("line: \(#line)")
}

let airportCodes = [String](airports.keys)
let airportNames = [String](airports.values)
print(
    "line: \(#line), type: \(type(of: airportCodes)), \(type(of: airportNames))"
)
