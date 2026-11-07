struct SizeForStruct {
    var width: Int = 3
    var height: Int = 5
}

class SizeForClass {
    var width: Int = 3
    var height: Int = 5
}

// 1. struct有一个自动生成的成员逐一构造器
// 2. struct在代码传递中会复制
let sfs = SizeForStruct(width: 20, height: 30)
print("line: \(#line)", "\(sfs)")
var sfsCopy = sfs
sfsCopy.width = 99
sfsCopy.height = 101
print("line: \(#line)", "sfs: \(sfs)", "sfsCopy: \(sfsCopy)")

// 1. 类实例没有默认成员逐一构造器
// 2. class在代码传递中，值不会复制
let sfc = SizeForClass()
print("line: \(#line)", "\(sfc.width)")
var sfcRef = sfc
sfcRef.width = 200
print("line: \(#line)", "sfc: \(sfc.width)", "sfcRef: \(sfcRef.width)")

// 1. 判断是否引用同一个实例
let sfc2 = SizeForClass()
if sfc === sfcRef {
    print("line: \(#line)", "引用相同实例")
}
if sfc !== sfc2 {
    print("line: \(#line)", "两个实例不相同")
}
