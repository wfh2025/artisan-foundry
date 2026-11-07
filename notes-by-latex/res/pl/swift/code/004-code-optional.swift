import Foundation

var input: String = "123"
var cvtNum: Int? = Int(input)
if cvtNum != nil {
    print("line:", "\(#line)", "info:", "\(type(of: cvtNum)), \(cvtNum!)")
}

if let cvtNum = cvtNum {
    print("line:", "\(#line)", "info:", "\(type(of: cvtNum)), \(cvtNum)")
}

if let cvtNum {
    print("line:", "\(#line)", "info:", "\(type(of: cvtNum)), \(cvtNum)")
}

if let num = cvtNum {
    print("line:", "\(#line)", "info:", "\(type(of: num)), \(num)")
}

if let firstNumber = Int("4"), let secondNumber = Int("42"),
    firstNumber < secondNumber && secondNumber < 100
{
    print("line:", "\(#line)", "info:", "\(firstNumber), \(secondNumber)")
}

if let firstNumber = Int("4") {
    if let secondNumber = Int("42") {
        if firstNumber < secondNumber && secondNumber < 100 {
            print(
                "line:", "\(#line)",
                "info:", "\(firstNumber), \(secondNumber)")
        }
    }
}

let possibleString: String? = "An optional string."
let forcedString: String = possibleString!
print(
    "line:", "\(#line)",
    "info:", "\(type(of: possibleString)), \(type(of: forcedString))"
)

let assumedString: String! = "An implicitly unwrapped optional string."
if assumedString != nil {
    print(
        "line:", "\(#line)",
        "info:", "\(type(of: assumedString)), \(assumedString!)"
    )
}
if let definiteString = assumedString {
    print(
        "line:", "\(#line)",
        "info:", "\(definiteString)"
    )
}
if let assumedString {
    print(
        "line:", "\(#line)",
        "info:", "\(assumedString)"
    )
}

let implicitString: String = assumedString
print(
    "line:", "\(#line)",
    "info:", "\(type(of: assumedString)), \(type(of: implicitString))"
)
