import Foundation

// MARK: - Chapter 3: Stacks & Queues

// MARK: Node
class Node: Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.val == rhs.val
    }
    
    var val: Int
    var next: Node?
    var ind: Int
    
    init() {
        val = 0
        next = nil
        ind = 0
    }
    
    init(val: Int) {
        self.val = val
        next = nil
        ind = 0
    }
    
    init(val: Int, next: Node?, ind: Int) {
        self.val = val
        self.next = next
        self.ind = ind
    }
    
    init(val: Int, next: Node?) {
        self.val = val
        self.next = next
        self.ind = 0
    }
}


// MARK: 3.6 Animal Shelter
class Shelter {
    var dogs: Node?
    var cats: Node?
    var ind: Int
    
    var firstDog: Node?
    var firstCat: Node?
    
    init() {
        dogs = nil
        cats = nil
        firstDog = nil
        firstCat = nil
        ind = 0
    }
    
    func enqueue(isCat: Bool) {
        var newNode: Node = .init()
        newNode.val = isCat ? 1 : 0
        newNode.ind = ind
        
        if isCat {
            newNode.next = cats
            cats = newNode
            
            if firstCat == nil {
                firstCat = newNode
            }
        } else {
            newNode.next = dogs
            dogs = newNode
            
            if firstDog == nil {
                firstDog = newNode
            }
        }
        
        ind += 1
    }
    
    func dequeue() -> Int? {
        if firstDog == nil && firstCat ==  nil {
            return nil
        } else if firstDog != nil && firstCat != nil {
            if firstDog!.ind < firstCat!.ind {
                return dequeueDog()
            } else {
                return dequeueCat()
            }
        } else if firstDog != nil {
            return dequeueDog()
        } else {
            return dequeueCat()
        }
    }
    
    func dequeueDog() -> Int? {
        guard firstDog != nil else { return nil }
        
        let val = firstDog!.ind
        
        var beforePrev: Node? = nil
        var prev: Node? = nil
        var cur = dogs
        
        while cur != nil {
            beforePrev = prev
            prev = cur
            cur = cur?.next
        }
        
        if beforePrev != nil {
            beforePrev?.next = nil
        }
        
        firstDog = beforePrev
        
        print("dequeueing dog")
        return val
    }
    
    func dequeueCat() -> Int? {
        guard firstCat != nil else { return nil }
        
        let val = firstCat!.ind
        
        var beforePrev: Node? = nil
        var prev: Node? = nil
        var cur = cats
        
        while cur != nil {
            beforePrev = prev
            prev = cur
            cur = cur?.next
        }
        
        if beforePrev != nil {
            beforePrev?.next = nil
        }
        
        firstCat = beforePrev
        
        print("dequeueing cat")
        return val
    }
}

let shelter: Shelter = .init()
shelter.enqueue(isCat: false)
shelter.enqueue(isCat: false)
shelter.enqueue(isCat: true)
shelter.enqueue(isCat: true)
shelter.enqueue(isCat: false)

print(shelter.dequeue(), "should be dog 0")
print(shelter.dequeueDog(), "should be dog 1")
print(shelter.dequeue(), "should be cat 2 ")


// MARK: 3.5 Sort stack
private func sortStack(_ stack: [Int]) -> [Int] {
    var firstStack: [Int] = stack
    var secStack: [Int] = []
    
    while !firstStack.isEmpty {
        let lastElement = firstStack.last!
        firstStack.removeLast()
        
        var cnt: Int = 0
        
        while !secStack.isEmpty && secStack.last! > lastElement {
            let lastFromSec = secStack.last!
            secStack.removeLast()
            firstStack.append(lastFromSec)
            cnt += 1
        }
        
        secStack.append(lastElement)
        
        while cnt > 0 {
            let last = firstStack.last!
            firstStack.removeLast()
            secStack.append(last)
            cnt -= 1
        }
    }
    
    return secStack
}

// MARK: 3.4 queue
class MyQueue {
    
    var firstStack: [Int]
    var secStack: [Int]
    
    init() {
        firstStack = []
        secStack = []
    }
    
    func dequeue() -> Int? {
        guard !firstStack.isEmpty else { return nil }
        
        while !firstStack.isEmpty {
            secStack.append(firstStack.last!)
            firstStack.removeLast()
        }
        
        let val = secStack.last!
        secStack.removeLast()
        
        while !secStack.isEmpty {
            firstStack.append(secStack.last!)
            secStack.removeLast()
        }
        
        return val
    }
    
    func enqueue(_ val: Int) {
        firstStack.append(val)
    }
}

//let queue: MyQueue = .init()
//queue.enqueue(1)
//queue.enqueue(2)
//queue.enqueue(3)
//print(queue.dequeue(), "should be 1")
//print(queue.dequeue(), "should be 2")
//print(queue.dequeue(), "should be 3")

// MARK: 3.3 Set of stacks
class SetOfStacks {
    var listOfLastNodes: [Node]
    let threshold: Int
    
    init(threshold: Int) {
        listOfLastNodes = []
        self.threshold = threshold
    }
    
    func pop() -> Int? {
        guard !listOfLastNodes.isEmpty else { return nil }
        
        let lastNode = listOfLastNodes.last!
        if lastNode.ind == 0 {
            listOfLastNodes.removeLast()
        } else {
            listOfLastNodes[listOfLastNodes.count-1] = lastNode.next!
        }
        
        return lastNode.val
    }
    
    func push(_ val: Int) {
        var newNode: Node = .init(val: val)
        if listOfLastNodes.isEmpty || listOfLastNodes.last!.ind == threshold - 1 {
            listOfLastNodes.append(newNode)
        } else {
            var lastNode = listOfLastNodes.last!
            newNode.next = lastNode
            newNode.ind = lastNode.ind + 1
            listOfLastNodes[listOfLastNodes.count - 1] = newNode
        }
    }
    
    func popAt(_ stackInd: Int) -> Int? {
        if listOfLastNodes.isEmpty || stackInd > listOfLastNodes.count - 1 {
            return nil
        }
        
        let oldNode = listOfLastNodes[stackInd]
        
        if oldNode.ind == 0 {
            listOfLastNodes.remove(at: stackInd)
        } else {
            listOfLastNodes[stackInd] = oldNode.next!
        }
        
        return oldNode.val
    }
}

//let st: SetOfStacks = .init(threshold: 3)
//print(st.pop(), "should pop nil")
//st.push(1)
//print(st.pop(), "should pop 1")
//
//st.push(1)
//st.push(2)
//st.push(3)
//st.push(4)
//print(st.pop(), "should pop 4")
//print(st.pop(), "should pop 3")
//print(st.pop(), "should pop 2")
//print(st.pop(), "should pop 1")
//print(st.pop(), "should pop nil")
//st.push(1)
//st.push(2)
//st.push(3)
//st.push(4)
//st.push(5)
//st.push(6)
//st.push(7)
//st.push(8)
//print(st.popAt(1), "should pop 6")
//print(st.popAt(1), "should pop 5")
//print(st.popAt(1), "should pop 4")
//print(st.popAt(1), "should pop 8")
//print(st.popAt(1), "should pop 7")
//print(st.popAt(0), "should pop 3")
