import UIKit
var N = 6
var Slices: Int {
    if N % 2 == 0{
        return N / 2
    } else {
        return (N / 2) + 1
    }
}
print(Slices)

// Optional Chaining

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
    init(name: String) { self.name = name}
}

class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    func buildingIdentifier() -> String? {
        if let buildingNumber = buildingNumber, let street = street {
            return "\(buildingNumber) , \(street)"
        } else if buildingName != nil {
            return buildingName
        } else {
            return nil
        }
    }
}

let john = Person()

john.residence = Residence()

if let roomCount = john.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}

func createAddress() -> Address {
    print("Function createAddress was called")
    
    let someAddress = Address()
    someAddress.buildingNumber = "29"
    someAddress.street = "Pushkin road"
//    someAddress.buildingName = "First"
    
    if (john.residence?.address = someAddress) != nil {
        print("It was possible to set the address.")
    } else {
        print("It was not possible to set the address.")
    }
    
    return someAddress
}
john.residence?.address = createAddress()

if john.residence?.printNumberOfRooms() != nil {
    print("It was possible to print the number of rooms.")
} else {
    print("It was not possible to print the number of rooms.")
}

let johnsHouse = Residence()
johnsHouse.rooms.append(Room(name: "Living Room"))
johnsHouse.rooms.append(Room(name: "Kitchen"))
john.residence = johnsHouse

if let firstRoomName = john.residence?[0].name {
    print("The first room name is \(firstRoomName).")
} else {
    print("Unable to retrieve the first room name.")
}

var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
testScores["Dave"]?[0] = 91
testScores["Bev"]?[0] += 1
testScores["Brian"]?[0] = 72
print (testScores)

let johnsAddress = Address()
johnsAddress.buildingName = "The Larches"
johnsAddress.street = "Laurel Street"
johnsAddress.buildingNumber = "First"
john.residence?.address = johnsAddress

if let johnsStreet = john.residence?.address?.street {
    print("John's street name is \(johnsStreet).")
} else {
    print("Unable to retrieve the address.")
}

if let buildingIdentifier = john.residence?.address?.buildingIdentifier() {
    print("John's building identifier is \(buildingIdentifier).")
}

if let beginsWithThe =
    john.residence?.address?.buildingIdentifier()?.hasPrefix("The") {
    if beginsWithThe {
        print("John's building identifier begins with \"The\".")
    } else {
        print("John's building identifier doesn't begin with \"The\".")
    }
}
