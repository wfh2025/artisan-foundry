class LongTimeTask {
}

struct Elements {
    let x1: Int
    var x2: Int

    // 存储属性
    var x3: Int {
        // 自定义名称: newIntValue
        // 默认名称: newValue
        willSet(newIntValue) {
            print(
                "line: \(#line)", "x3设置之前调用，从", "\(self.x3)", "\(newIntValue)")
        }

        // 自定义名称: oldIntValue
        // 默认名称: oldValue
        didSet(oldIntValue) {
            print(
                "line: \(#line)", "x3设置之后调用，从", "\(oldIntValue)", "\(self.x3)")
        }
    }

    // 计算属性
    var sum: Int {
        get {
            return x2 + x3
        }
        // 自定义名称: newSum
        set(newSum) {
            self.x2 = newSum / 2
            self.x3 = newSum / 2
        }
    }
    var sum2: Int {
        get {
            return x2 + x3
        }
        set {  // 默认名称: newValue
            self.x2 = newValue / 2
            self.x3 = newValue / 2
        }
    }
    var diff: Int {  // 只读计算属性
        return x2 - x3
    }

    // 延时加载属性
    lazy var x100: LongTimeTask = LongTimeTask()
}

var ele = Elements(x1: 1, x2: 2, x3: 3)
print("line: \(#line)", "\(ele)", "\(ele.diff)")
ele.sum = 4
print("line: \(#line)", "\(ele)")
ele.sum2 = 6
print("line: \(#line)", "\(ele)")

func changeNum(_ a: inout Int) {
    a = 100
}
changeNum(&(ele.x3))
print("line: \(#line)", "\(ele)")
