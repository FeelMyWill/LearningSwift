import UIKit

struct Canvas {
    private var shapes = List<Shape>()
    private var nodes = [Shape.ID : List<Shape>.Node]()

    func render() -> Image {
        let context = DrawingContext()
        shapes.forEach(context.draw)
        return context.makeImage()
    }

    mutating func add(_ shape: Shape) {
        nodes[shape.id] = shapes.append(shape)
    }

    mutating func remove(_ shape: Shape) {
        guard let node = nodes.removeValue(forKey: shape.id) else {
            return
        }

        shapes.remove(node)
    }
}

struct List<Value> {
    private(set) var firstNode: Node?
    private(set) var lastNode: Node?
}

extension List {
    class Node {
        var value: Value
        fileprivate(set) weak var previous: Node?
        fileprivate(set) var next: Node?
        
        init(value: Value) {
            self.value = value
        }
    }
}

extension List {
    func makeIterator() -> AnyIterator<Value> {
        var node = firstNode
        
        return AnyIterator {
            let value = node?.value
            node = node?.next
            return value
        }
    }
}

protocol ClassicIteratorProtocol: IteratorProtocol {
    var currentItem: Element? { get }
    var first: Element? { get }
    var isDone: Bool { get }
}

//Изменение связного узла - добавление узла (элемента)
extension List {
    @discardableResult
    mutating func append(_ value: Value) -> Node {
        let node = Node(value: value)
        node.previous = lastNode

        lastNode?.next = node
        lastNode = node

        if firstNode == nil {
            firstNode = node
        }

        return node
    }
}

//Удаление узла(элемента)
extension List {
    mutating func remove(_ node: Node) {
        node.previous?.next = node.next
        node.next?.previous = node.previous

        // Используя «тройное равенство», мы можем сравнивать два экземпляра класса по тождеству, а не по значению:
        if firstNode === node {
            firstNode = node.next
        }

        if lastNode === node {
            lastNode = node.previous
        }
    }
}



// Паттерн "классический итератор"
//
//struct ShelfIterator: ClassicIteratorProtocol {
//    var currentItem: Book? = nil
//    var first: Book?
//    var isDone: Bool = false
//    private var books: [Book]
//
//    init(books: [Book]) {
//        self.books = books
//        first = books.first
//        currentItem = books.first
//    }
//
//    mutating func next() -> Book? {
//        currentItem = books.first
//        books.removeFirst()
//        isDone = books.isEmpty
//        return books.first
//    }
//}
//
//func printShelf(with iterator: inout ShelfIterator) {
//    var bookIndex = 0
//    while !iterator.isDone {
//        bookIndex += 1
//        print("\(bookIndex). \(iterator.currentItem!.author) – \(iterator.currentItem!.title)")
//        _ = iterator.next()
//    }
//}
//
//var iterator = ShelfIterator(books: shelf.books)
//printShelf(with: &iterator)


