import UIKit

enum StackError: Error {
    case Empty(message: String)
}

protocol Stackable {
    // Вы можете добавить ограничения к связанному типу в протоколе для гарантии соответствия связанных типов этим ограничениям.
    associatedtype Element: Equatable
    //Теперь тип элемента стека должен соответствовать Equatable, иначе произойдет ошибка времени компиляции.
    mutating func push(element: Element)
    mutating func pop() -> Element?
    func peek() throws -> Element
    func isEmpty() -> Bool
    func count() -> Int
    subscript(i: Int) -> Element { get }
}

public struct Stack<T>: Stackable {
    public typealias Element = T
    
    var array: [T] = []
    
    init(capacity: Int) {
        array.reserveCapacity(capacity)
    }
    
    public mutating func push(element: T) {
        array.append(element)
    }
    
    public mutating func pop() -> T? {
        return array.popLast()
    }
    
    public func peek() throws -> T {
        guard !isEmpty(), let lastElement = array.last else {
            throw StackError.Empty(message: "Array is empty")
        }
        return lastElement
    }
    
    func isEmpty() -> Bool {
       return array.isEmpty
    }
    
    func count() -> Int {
        return array.count
    }
}

extension Stack: Collection {
    public func makeIterator() -> AnyIterator<T> {
        var curr = self
        return AnyIterator { curr.pop() }
    }
    
    public subscript(i: Int) -> T {
        return array[i]
    }
    
    public var startIndex: Int {
        return array.startIndex
    }
    
    public var endIndex: Int {
        return array.endIndex
    }
    
    public func index(after i: Int) -> Int {
        return array.index(after: i)
    }
}

extension Stack: CustomStringConvertible {
    public var description: String {
        let header = "***Stack Operations start*** "
        let footer = " ***Stack Operation end***"
        let elements = array.map{ "\($0)" }.joined(separator: "\n")
        return header + elements + footer
    }
}

var stack = Stack<Int>(capacity: 10)
stack.push(element: 1)
stack.pop()

stack.push(element: 3)
stack.push(element: 4)
print(stack)


//Вы можете расширить существующий тип, чтобы обеспечить соответствие протоколу.

protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
extension Array: Container {}

// Мы создали стек типа Т, но мы не можем сравнивать два стека, поскольку здесь типы не соответствуют Equatable. Нам нужно изменить это, чтобы использовать Stack<T: Equatable>

// Расширение добавляет метод isTop (_ :) только тогда, когда элементы в стеке поддерживают Equatable. Также вы можете использовать generic-условие where с расширениями протокола. К условию where можно добавить несколько требований, разделив их запятой.

extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}

extension Stack {
   var topItem: Element? {
     return items.isEmpty ? nil : items[items.count - 1]
   }
}

//Протокол может являться частью собственных требований.
//
//protocol SuffixableContainer: Container {
//    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
//    func suffix(_ size: Int) -> Suffix
//}

//Вы можете использовать generic-условие where как часть расширения. Приведенный ниже пример расширяет общую структуру Stack из предыдущих примеров, с помощью добавления метода isTop (_ :).

//Расширение добавляет метод isTop (_ :) только тогда, когда элементы в стеке поддерживают Equatable. Также вы можете использовать generic-условие where с расширениями протокола. К условию where можно добавить несколько требований, разделив их запятой.

extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}

//Специализация дженериков
//
//Специализация дженериков означает, что компилятор клонирует универсальный тип или функцию, такую как Stack <T>, для конкретного типа параметра, такого как Int. Эта специализированная функция может быть затем оптимизирована специально для Int, при этом все лишнее будет удалено. Процесс замены параметров типа аргументами типа во время компиляции называется специализацией.
//
//Специализируя generic-функцию для этих типов, мы можем исключить затраты на виртуальную диспетчеризацию, инлайн вызовы, когда это необходимо, и устранить накладные расходы дженерик системы.

//Generic-типы по умолчанию не работают с операторами, для этого вам нужен протокол.

func ==<T: Equatable>(lhs: Matrix<T>, rhs: Matrix<T>) -> Bool {
    return lhs.array == rhs.array
}
