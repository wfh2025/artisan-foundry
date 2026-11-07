class Person {
    var residence: Residence?
}
class Residence {
    var rooms: [Room] = []
    var numberOfRooms: Int {
        return rooms.count
    }
    subscript(i: Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    func printNumberOfRooms() {
        print("The number of rooms is \(numberOfRooms)")
    }
    var address: Address?
}

class Room {
    let name: String
    init(name: String) { self.name = name }
}

class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    var addrValue: String = "XXX"
    func buildingIdentifier() -> String? {
        if buildingName != nil {
            return buildingName
        } else if let buildingNumber = buildingNumber, let street = street {
            return "\(buildingNumber) \(street)"
        } else {
            return nil
        }
    }
}

let john = Person()
print("line: \(#line), parms: \(type(of: john.residence?.numberOfRooms))")
//let roomCount = john.residence!.numberOfRooms // 强制解包,可能崩溃

if let roomCount = john.residence?.numberOfRooms {
    print("line: \(#line)", "John's residence has \(roomCount) room(s).")
} else {
    print("line: \(#line)", "Unable to retrieve the number of rooms.")
}

// 赋值失败
let someAddress: Address = Address()
someAddress.buildingName = "29"
someAddress.street = "Acacia Road"
john.residence?.address = someAddress
print("line: \(#line)", "parms: \(String(describing: john.residence))")

func createAddress() -> Address {
    print("Function was called.")

    let someAddress = Address()
    someAddress.buildingNumber = "29"
    someAddress.street = "Acacia Road"

    return someAddress
}

// 没有执行，建议先判断值在赋值，否则会有异常
john.residence?.address = createAddress()
print("line: \(#line)", "parms: \(String(describing: john.residence))")
if (john.residence?.address = someAddress) != nil {
    print("line: \(#line)", "It was possible to set the address.")
} else {
    print("line: \(#line)", "It was not possible to set the address.")
}

if john.residence?.printNumberOfRooms() != nil {
    print("line: \(#line)", "It was possible to print the number of rooms.")
} else {
    print("line: \(#line)", "It was not possible to print the number of rooms.")
}

print(
    "line: \(#line)", "parms: \(type(of: john.residence?.printNumberOfRooms()))"
)

if let firstRoomName = john.residence?[0].name {
    print("line: \(#line)", "The first room name is \(firstRoomName).")
} else {
    print("line: \(#line)", "Unable to retrieve the first room name.")
}

if (john.residence?[0] = Room(name: "Bathroom")) != nil {
    print("line: \(#line)", "Succeed to set residence first room")
} else {
    print("line: \(#line)", "Failed to set residence first room")
}

let johnsHouse = Residence()
johnsHouse.rooms.append(Room(name: "Living Room"))
johnsHouse.rooms.append(Room(name: "Kitchen"))
john.residence = johnsHouse

if let firstRoomName = john.residence?[0].name {
    print("line: \(#line)", "The first room name is \(firstRoomName).")
} else {
    print("line: \(#line)", "Unable to retrieve the first room name.")
}

if (john.residence?[0] = Room(name: "Bathroom")) != nil {
    print(
        "line: \(#line)", "Succeed to set residence room",
        "\(john.residence![0].name)")
} else {
    print("line: \(#line)", "Failed to set residence first room")
}

var testScores: [String: [Int]] = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
testScores["Dave"]?[0] = 91
testScores["Bev"]?[0] += 1
testScores["Brian"]?[0] = 72

// 注意: testScores["feihu"] = [1, 2] 与testScores["feihu"]? = [1, 2] 的结果
print("line: \(#line)", type(of: testScores["Dave"]))
print("line: \(#line)", testScores)

print("line: \(#line)", type(of: john.residence?.address?.street))
print("line: \(#line)", type(of: john.residence?.address?.addrValue))
if let johnsStreet = john.residence?.address?.street {
    print("line: \(#line)", "John's street name is \(johnsStreet).")
} else {
    print("line: \(#line)", "Unable to retrieve the address.")
}

let johnsAddress = Address()
johnsAddress.buildingName = "The Larches"
johnsAddress.street = "Laurel Street"
john.residence?.address = johnsAddress

if let beginsWithThe =
    john.residence?.address?.buildingIdentifier()?.hasPrefix("The")
{
    if beginsWithThe {
        print(
            "line: \(#line)", "John's building identifier begins with \"The\".")
    } else {
        print(
            "line: \(#line)",
            "John's building identifier does not begin with \"The\".")
    }
}

