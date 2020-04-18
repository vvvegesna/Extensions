import Foundation

struct LinkedList<Value> {
    private(set) var firstNode: Node?
    private(set) var lastNode: Node?
}

extension LinkedList {
    class Node {
        var value: Value
        fileprivate(set) weak var previous: Node?
        fileprivate(set) var next: Node?

        init(value: Value) {
            self.value = value
        }
    }
}

extension LinkedList: Sequence {
    func makeIterator() -> AnyIterator<LinkedList<Value>.Node> {
        var node = firstNode

        return AnyIterator {
            let currentNode = node
            node = node?.next
            return currentNode
        }
    }
}

extension LinkedList {
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
    
    mutating func remove(_ node: Node) {
        node.previous?.next = node.next
        node.next?.previous = node.previous

        if firstNode === node {
            firstNode = node.next
        }

        if lastNode === node {
            lastNode = node.previous
        }
        
        node.next = nil
        node.previous = nil
    }
    
    mutating func moveToFirst(_ node: Node) {
        guard !(node === firstNode) else {
            return
        }
        node.previous?.next = node.next
        node.next?.previous = node.previous
        
        if node === lastNode {
            lastNode = node.previous
        }
        
        node.next = firstNode
        firstNode = node
    }
}

struct MetadataRecordTypes {
    let fullName: String
    let active: Bool?
}

var recordTypesList = LinkedList<MetadataRecordTypes>()
let recordTypes = [MetadataRecordTypes(fullName: "Attendee", active: false), MetadataRecordTypes(fullName: "Speaker", active: false), MetadataRecordTypes(fullName: "WriteIns", active: false), MetadataRecordTypes(fullName: "Colleague", active: true)]

let sortedRecordTypes = recordTypes.sorted { $0.fullName < $1.fullName }
var nodesLookUp = [Int: LinkedList<MetadataRecordTypes>.Node]()

sortedRecordTypes.forEach { recordTypesList.append($0) }

recordTypesList.forEach {
    print($0.value.fullName)
}
print("--->:")
recordTypesList.forEach { node in
    if node.value.active == true {
        recordTypesList.moveToFirst(node)
        return
    }
}
recordTypesList.forEach {
    print($0.value.fullName)
}

let arrayElements = recordTypesList.map { $0 }
