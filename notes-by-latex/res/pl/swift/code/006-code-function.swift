import Foundation

func get2Nums(arr: [Int]) -> (n1: Int, n2: Int)? {
    if arr.isEmpty {
        return nil
    }
    return (arr[0], arr[arr.count - 1])
}

_ = get2Nums(arr: [8, -6, 2, 109])

if let nums = get2Nums(arr: [8, -6, 2, 109]) {
    print("line: \(#line)", "info", "\(nums.n1)", "\(nums.1)")
}

func greeting(for person: String) -> String {
    "Hello, " + person
}
print("line: \(#line)", "info", "\(greeting(for: "kugou"))")

func greet(person: String, from hometown: String = "CN") -> String {
    return "\(person) " + "\(hometown)"
}
print(
    "line: \(#line)", "info", "\(greet(person: "Bill", from: "Cupertino"))",
    "\(greet(person: "Fei"))")

func greet2(_ person: String, from hometown: String) -> String {
    return greet(person: person, from: hometown)
}
print("line: \(#line)", "info", "\(greet2("Bill", from: "Cupertino"))")

func calcMean(_ nums: Double...) -> Double {
    if nums.isEmpty {
        return Double(0)
    }
    var total = Double(0)
    for num in nums {
        total += num
    }
    return total / Double(nums.count)
}
print("line: \(#line)", "info", "\(calcMean(1,2,3,4))")

var x = 3
var y = 4
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let tmp = a
    a = b
    b = tmp
}
swapTwoInts(&x, &y)
print("line: \(#line)", "info", "\(x)", "\(y)")

func add(_ a: Int, _ b: Int) -> Int {
    return a + b
}

var mathFunc: (Int, Int) -> Int = add
print("line: \(#line)", "info", "\(type(of: mathFunc))", "\(mathFunc(2, 3))")

func execCallBack(_ cb: (Int, Int) -> Int, _ a: Int, _ b: Int) -> Int {
    return cb(a, b)
}
print("line: \(#line)", "\(execCallBack(add, 3, 4))")

func getCallBack() -> ((Int, Int) -> Int) {
    return add
}

let cb = getCallBack()
print("line: \(#line)", "\(cb(5, 4))")

func chooseStepFunc(_ backward: Bool) -> ((Int) -> Int) {
    func stepForward(input: Int) -> Int {
        return input + 1
    }
    func stepBackward(input: Int) -> Int {
        return input - 1
    }
    return backward ? stepBackward : stepForward
}

let stepFunc = chooseStepFunc(true)

print("line: \(#line)", "\(stepFunc(5))")
