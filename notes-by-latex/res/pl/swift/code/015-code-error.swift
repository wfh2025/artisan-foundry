enum CustomError: Error {
    case invalid
    case notEqual(input: Int, wanted: Int)
    case noData(index: Int)
}

enum CommonError: Error {
    case unknow
}

func getResultWithError(_ index: Int, _ wanted: Int) throws -> String {
    guard index != 2 else {
        throw CommonError.unknow
    }
    guard index >= 0 else {
        throw CustomError.invalid
    }
    guard index == wanted else {
        throw CustomError.notEqual(input: index, wanted: wanted)
    }

    let arr: [String] = ["A", "B", "C", "D"]
    guard index < arr.count else {
        throw CustomError.noData(index: index)
    }

    return arr[index]
}

do {
    let _ = try getResultWithError(1, 1)
    print("line: \(#line)", "call ok")
} catch CustomError.invalid {
    print("line: \(#line)", "invalid")
} catch CustomError.noData(let index) {
    print("line: \(#line)", "no data", "index: \(index)")
} catch CustomError.notEqual(let input, let wanted) {
    print("line: \(#line)", "no equal", "input: \(input)", "wanted: \(wanted)")
} catch {
    print("line: \(#line)", "unknow")
}

_ = try! getResultWithError(3, 3)

func f(_ index: Int, _ wanted: Int) throws {
    let _ = try getResultWithError(index, wanted)
}

func main() throws {
    do {
        let _ = try getResultWithError(2, 99)
    } catch is CustomError {
        print("line: \(#line)", "custom error")
    }
}

do {
    try main()
} catch {
    print("line: \(#line)", "unknow")
}

if let data = try? getResultWithError(3, 3) {
    print("line: \(#line)", "\(data)")
} else {
    print("line: \(#line)", "meet error")
}

if (try? getResultWithError(3, 4)) != nil {
    print("line: \(#line)")
} else {
    print("line: \(#line)", "meet error")
}

let m = try! getResultWithError(3, 3)
print("line: \(#line)", "\(type(of: m))")
