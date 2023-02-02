import UIKit

var greeting = "Hello, playground"

// MARK: Example 1 - Final Class
final class ClassExample1 {
    // MARK: Direct Dispatch
    func doSomething() {
        print("Example 1 - Final Class")
    }
}

protocol SomeProtocol {}

// MARK: Example 2 - Protocol Extension
extension SomeProtocol {
    // MARK: Direct Dispatch
    func doSomething() {
        print("Example 2 - Protocol Extension")
    }
}

class ClassExample2: SomeProtocol {}

let classExample2 = ClassExample2()
classExample2.doSomething()

// MARK: Example 3 - Class Extension
class ClassExample3 {}

extension ClassExample3 {
    // MARK: Direct Dispatch
    func doSomething() {
        print("Example 3 - Class Extension")
    }
}
let classExample3 = ClassExample3()
classExample3.doSomething()

// MARK: Example 4 - Access Control
class ClassExample4 {
    func doSomething() {
        doSomethingPrivate()
    }
    
    // MARK: Direct Dispatch
    private func doSomethingPrivate() {
        print("Example 4 - Access Control")
    }
}

// MARK: Example 5 - Virtual Table
class ClassExample5 {
    func doSomething() {
        print("Example 5 - Virtual Table")
    }
}

class SubclassExample5: ClassExample5 {
    override func doSomething() {
        print("Override for subclass")
    }

    func doSomething2() {
        print("Method of subclass")
    }
}

// MARK: Example 6 - Witness Table
protocol ProtocolExample6 {
    func doSomething()
}

class ClassExample6: ProtocolExample6 {
    func doSomething() {
        print("Example 6 - Witness Table")
    }
}

class AnotherClassExample6: ProtocolExample6 {
    func doSomething() {
        print("Hello World")
    }
}

protocol MethodDispatch {
    func methodA() // Dynamic dispatch
    func methodC() // Dynamic dispatch
}

extension MethodDispatch {
    func methodB() { // Static dispatch
        print("B")
    }
    func methodC() { // Dynamic dispatch
        print("C")
    }
}

// MARK: Example 8 - First Bug
protocol ProtocolExample8 {}

extension ProtocolExample8 {
    func doSomething() {
        print("Default Implementation")
    }
}

class ClassExample8: ProtocolExample8 {
    func doSomething() {
        print("Required Implementation")
    }
}

let first = ClassExample8()
let second: ProtocolExample8 = ClassExample8()
first.doSomething()
second.doSomething()

// MARK: Example 7 - All types of dispatching
protocol ProtocolExample7 {
    func doSomethingWithWitnessTable()
}
class ClassExample7: NSObject {
    @objc dynamic func doSomething() {
        print("Example 7 - Message Dispatch")
    }
}
class SubclassExample7: ClassExample7, ProtocolExample7 {
    private func doSomethingWithDirectDispatch() {
        print("Direct Dispatch")
    }
    func doSomethingWithVirtualTable() {
        print("Virtual Table")
    }
    func doSomethingWithWitnessTable() {
        print("Witness Table")
    }
    @objc override dynamic func doSomething() {
        print("Override with Message Dispatch")
    }
}
