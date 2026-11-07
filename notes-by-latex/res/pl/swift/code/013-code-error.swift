enum VendingMachineError: Error {
    case invalidSelection  //选择无效
    case insufficientFunds(coinsNeeded: Int)  //金额不足
    case outOfStock  //缺货
}

struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11),
    ]
    var coinsDeposited = 0

    func vend(itemNamed name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }

        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }

        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(
                coinsNeeded: item.price - coinsDeposited)
        }

        coinsDeposited -= item.price

        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        print("line: \(#line), parms: \(name)")
    }
}

func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let favoriteSnacks = [
        "Alice": "Chips",
        "Bob": "Licorice",
        "Eve": "Pretzels",
    ]

    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vendingMachine.vend(itemNamed: snackName)
}

struct PurchasedSnack {
    let name: String
    init(name: String, vendingMachine: VendingMachine) throws {
        try vendingMachine.vend(itemNamed: name)
        self.name = name
    }
}

var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8
do {
    try buyFavoriteSnack(person: "Alice2", vendingMachine: vendingMachine)
    print("line: \(#line)", "Success! Yum.")
} catch VendingMachineError.invalidSelection {
    print("line: \(#line)", "Invalid Selection.")
} catch VendingMachineError.outOfStock {
    print("line: \(#line)", "Out of Stock.")
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
    print(
        "line: \(#line)",
        "Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
} catch {
    print("line: \(#line)", "Unexpected error: \(error).")
}
func nourish(with item: String) throws {
    do {
        try vendingMachine.vend(itemNamed: item)
    } catch is VendingMachineError {
        print("line: \(#line)", "Couldn't buy that from the vending machine.")
    }
}

do {
    try nourish(with: "Beet-Flavored Chips")
} catch {
    print(
        "line: \(#line)",
        "Unexpected non-vending-machine-related error: \(error)")
}

func eat(item: String) throws {
    do {
        try vendingMachine.vend(itemNamed: item)
    } catch VendingMachineError.invalidSelection,
        VendingMachineError.insufficientFunds,
        VendingMachineError.outOfStock
    {
        print(
            "line: \(#line)",
            "Invalid selection, out of stock, or not enough money.")
    }
}
