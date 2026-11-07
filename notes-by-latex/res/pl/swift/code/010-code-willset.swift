import Foundation

struct Size {
    var num: Int {
        willSet(newNum) {
            print("line: \(#line)", "willSet", "\(newNum)")
            print("line: \(#line)", "cur num", "\(num)")
        }
        didSet(oldNum) {
            print("line: \(#line)", "cur num", "\(num)")
            print("line: \(#line)", "didSet", "\(oldNum)")
        }
    }
}

var s = Size(num: 3)
s.num = 9
print("line: \(#line)", "\(s)")

print("line: \(#line)", "-----------------------")
func changeNum(_ a: inout Int) {
    a = 100
}
changeNum(&(s.num))
print("line: \(#line)", "\(s)")
