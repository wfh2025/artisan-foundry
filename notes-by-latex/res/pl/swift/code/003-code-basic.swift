import Foundation

let minValOfUInt8 = UInt8.min
let maxValOfUInt8 = UInt8.max
let minValOfInt = Int.min
let maxValOfInt = Int.max
print(
    "line: \(#line), params: \(minValOfUInt8), \(maxValOfUInt8), \(minValOfInt), \(maxValOfInt)"
)

let decimalInteger = 17
let binaryInteger = 0b10001
let octalInteger = 0o21
let hexadecimalInteger = 0x11
print(
    "line: \(#line), params: \(decimalInteger), \(binaryInteger), \(octalInteger), \(hexadecimalInteger)"
)

let decimalDouble = 12.1875
let exponentDouble = 1.21875e1
let hexadecimalDouble = 0xC.3p0
print(
    "line: \(#line), params: \(decimalDouble), \(exponentDouble), \(hexadecimalDouble)"
)

let paddedDouble = 000123.456
let oneMillion = 1_000_000
let justOverOneMillion = 1_000_000.000_000_1
print(
    "line: \(#line), params: \(paddedDouble), \(oneMillion), \(justOverOneMillion)"
)

typealias AudioSample = UInt16
var maxSampleFound = AudioSample.min
print(
    "line: \(#line), params: \(maxSampleFound), \(type(of: maxSampleFound))"
)

let http404Error = (404, "Not Found")
let (statusCode, statusMessage) = http404Error
let (justTheStatusCode, _) = http404Error
let http200Status = (statusCode: 200, description: "OK")
print(
    "line: \(#line),",
    "params: \(http404Error.0), \(http404Error.1),",
    "\(statusCode), \(statusMessage), \(justTheStatusCode)",
    "\(http200Status.statusCode), \(http200Status.1)"
)
