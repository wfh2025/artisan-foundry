import Foundation

func testClosure(
    _ a: Int, _ b: Int,
    callBackShow: () -> Void,
    callBackAdd: (_ a: Int, _ b: Int) -> Int,
    callBackSub: (_ a: Int, _ b: Int) -> Int,
    callBackMulti: (_ a: Float64, _ b: Float64) -> Float64,
    callBackDivide: (_ a: Float64, _ b: Float64) -> Float64
) -> (Int, Int, Float64, Float64) {
    let add: Int = callBackAdd(a, b)
    let sub: Int = callBackSub(a, b)
    let multi: Float64 = callBackMulti(Float64(a), Float64(b))
    let divide: Float64 = callBackDivide(Float64(a), Float64(b))
    callBackShow()
    return (add, sub, multi, divide)
}


var m: (Int, Int, Double, Double) = testClosure(
    6, 3,
    callBackShow: {
        () -> Void in
        print("line: \(#line)", "xxxx")
    },
    callBackAdd: {
        a, b in
        return a + b
    },
    callBackSub: {
        return $0 - $1
    },
    callBackMulti: {
        (a: Float64, b: Float64) -> Float64 in
        return a * b
    },
    callBackDivide: {
        (a: Float64, b: Float64) -> Float64 in
        return a / b
    }
)
print("line: \(#line)", "\(type(of: m))", "\(m)")

m = testClosure(
    6, 3,
    callBackShow: {
        () -> Void in
        print("line: \(#line)", "xxxx")
    },
    callBackAdd: {
        a, b in
        return a + b
    },
    callBackSub: {
        return $0 - $1
    },
    callBackMulti: {
        (a: Float64, b: Float64) -> Float64 in
        return a * b
    }
) { // 尾随闭包(最后一个参数)
    (a: Float64, b: Float64) -> Float64 in
    return a / b
}
print("line: \(#line)", "\(type(of: m))", "\(m)")

m = testClosure(
    6, 3,
    callBackShow: {
        () -> Void in
        print("line: \(#line)", "xxxx")
    },
    callBackAdd: {
        a, b in
        return a + b
    },
    callBackSub: {
        return $0 - $1
    }
) { // 尾随闭包(第一个省略参数标签)
    (a: Float64, b: Float64) -> Float64 in
    return a * b
} callBackDivide: { // 尾随闭包(其他的不能省略标签)
    (a: Float64, b: Float64) -> Float64 in
    return a / b
}
print("line: \(#line)", "\(type(of: m))", "\(m)")


