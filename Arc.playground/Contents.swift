import UIKit

class Person {
    var department: Department
    init() {
        print("person object initialized")
    }
    
    deinit {
        print("person object deallocated")
    }
}

class Department {
    init() {
        print("department object initialized")
    }
    
    deinit {
        print("department object deallocated")
    }
}

var p1: Person? = Person()
var d1: Department? = Department()

p1?.department = d1!
p1 = nil

print("department deallocate method is not called")
d1 = nil
