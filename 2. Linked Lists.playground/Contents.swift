import Foundation

// MARK: - Chapter 2: Linked Lists

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

// MARK: problem 2.7
private func hasIntersection(_ l1: Node?, _ l2: Node?) -> Node? {
    let l1L = lengthOfList(l1)
    let l2L = lengthOfList(l2)
    
    var longestList: Node?
    var shortestList: Node?
    
    if l1L > l2L {
        longestList = l1
        shortestList = l2
    } else {
        longestList = l2
        shortestList = l1
    }
    
    var cnt = max(l1L, l2L) - min(l1L, l2L)
    while cnt > 0 && longestList != nil {
        longestList = longestList?.next
        cnt -= 1
    }
    
    while longestList != nil && longestList !== shortestList {
        longestList = longestList?.next
        shortestList = shortestList?.next
    }
    
    return longestList
}

var n6: Node? = .init(val: 5, next: nil)
var n5: Node? = .init(val: 5, next: n6)
var n4: Node? = .init(val: 3, next: n5)
var n3: Node? = .init(val: 3, next: n4)
var n2: Node? = .init(val: 9, next: n3)
var n1: Node? = .init(val: 5, next: n2)


var l2: Node? = .init(val: 19)
var l1: Node? = .init(val: 10, next: l2)


var tmp: Node? = hasIntersection(l1, n1)
while (tmp != nil) {
    print(tmp!.val)
    tmp = tmp?.next
}

// MARK: problem 2.6
private func isPalindrome(_ head: Node?) -> Bool {
    guard head != nil else { return true }
    
    var curNode: Node? = head?.next
    var reversed: Node? = .init(val: head!.val, next: nil)
    
    var tmp: Node?
    while curNode != nil {
        tmp = .init(val: curNode!.val, next: reversed)
        reversed = tmp
        curNode = curNode?.next
    }
    
    curNode = head
    
    while curNode != nil && reversed != nil {
        if curNode!.val != reversed!.val {
            return false
        }
        
        curNode = curNode?.next
        reversed = reversed?.next
    }
    
    return true
}

private func isPalindromeStack(_ head: Node?) -> Bool {
    var slowPtr: Node? = head
    var fastPtr: Node? = head
    var intStack: [Int] = []
    
    while fastPtr?.next != nil {
        intStack.append(slowPtr!.val)
        slowPtr = slowPtr?.next
        fastPtr = fastPtr?.next?.next
    }
    
    if fastPtr != nil {
        slowPtr = slowPtr?.next
    }
    
    while slowPtr != nil {
        if slowPtr!.val != intStack.last! {
            return false
        }
        intStack.removeLast()
        slowPtr = slowPtr?.next
    }
    
    return true
}

// MARK: problem 2.5
private func sumLists(_ l1: Node?, _ l2: Node?) -> Node? {
    var res: Node? = .init(val: -1, next: nil)
    var curRes: Node? = res
    
    var curL1: Node? = l1
    var curL2: Node? = l2
    
    var carry: Int = 0
    while curL1 != nil && curL2 != nil {
        curRes?.next = .init(val: (curL1!.val + curL2!.val + carry) % 10, next: nil)
        carry = (curL1!.val + curL2!.val + carry) / 10
        curRes = curRes?.next
        
        curL1 = curL1?.next
        curL2 = curL2?.next
    }
    
    while curL1 != nil {
        curRes?.next = .init(val: (curL1!.val + carry) % 10, next: nil)
        carry = (curL1!.val + carry) / 10
        curRes = curRes?.next
        
        curL1 = curL1?.next
    }
    
    while curL2 != nil {
        curRes?.next = .init(val: (curL2!.val + carry) % 10, next: nil)
        carry = (curL2!.val + carry) / 10
        curRes = curRes?.next
        
        curL2 = curL2?.next
    }
    
    if carry > 0 {
        curRes?.next = .init(val: 1, next: nil)
    }
    
    return res?.next
}

private func sumListsForward(_ l1: Node?, _ l2: Node?) -> Node? {
    let l1L: Int = lengthOfList(l1)
    let l2L: Int = lengthOfList(l2)
    
    var _l1 = l1
    var _l2 = l2
    if l1L < l2L {
        insertPadding(&_l1, count: l2L - l1L)
    } else if l2L < l1L {
        insertPadding(&_l2, count: l1L - l2L)
    }
    
    var carry: Int = 0
    let result: Node? = sumListsForwardRec(_l1, _l2, carry: &carry)
    if carry != 0 {
        return .init(val: carry, next: result)
    }
    return result
}

private func sumListsForwardRec(_ l1: Node?, _ l2: Node?, carry: inout Int) -> Node? {
    guard l1 != nil && l2 != nil else { return nil }
    
    let next: Node? = sumListsForwardRec(l1?.next, l2?.next, carry: &carry)
    let newNode: Node? = .init(val: (l1!.val + l2!.val + carry) % 10, next: next)
    carry = (l1!.val + l2!.val + carry) / 10
    
    return newNode
}

private func printList(_ l: Node?) {
    var list = l
    while list != nil {
        print(list?.val)
        list = list?.next
    }
}

private func insertPadding(_ head: inout Node?, count: Int) {
    guard head != nil else { return }

    var cnt = 0
    var tmp: Node?
    while cnt < count {
        tmp = .init(val: head!.val, next: head!.next)
        head?.val = 0
        head?.next = tmp
        cnt += 1
    }
}

private func lengthOfList(_ head: Node?) -> Int {
    var cnt = 0
    
    var cur = head
    while cur != nil {
        cnt += 1
        cur = cur?.next
    }
    
    return cnt
}

// MARK: problem 2.4
private func partitionList(_ head: Node?, partition: Int) -> Node? {
    var res: Node? = .init(val: -1, next: nil)
    var leftEnd: Node? = res
    var right: Node? = .init(val: -1, next: nil)
    
    var curNode: Node? = head
    
    var tmpNode: Node?
    var newNode: Node?
    
    while curNode != nil {
        if curNode!.val < partition {
            newNode = .init(val: curNode!.val, next: nil)
            leftEnd?.next = newNode
            leftEnd = newNode
        } else {
            tmpNode = right?.next
            newNode = .init(val: curNode!.val, next: tmpNode)
            right?.next = newNode
        }
        curNode = curNode?.next
    }
    
    leftEnd?.next = right?.next
    
    return res?.next
}

private func partitionListBetter(_ head: Node?, partition: Int) -> Node? {
    var left: Node? = head
    var right: Node? = head
    
    var curNode: Node? = head
    var nextNode: Node?
    while curNode != nil {
        nextNode = curNode?.next
        if curNode!.val < partition {
            curNode?.next = left
            left = curNode
        } else {
            right?.next = curNode
            right = curNode
        }
        
        curNode = nextNode
    }
    right?.next = nil
    
    return left
}

// MARK: problem 2.3
private func deleteMiddleNodeReal(_ middle: inout Node?) {
    if middle == nil || middle?.next == nil {
        middle = nil
        return
    }
    
//    middle?.val = middle!.next!.val
//    middle?.next = middle!.next!.next
    middle = .init(val: middle!.next!.val, next: middle!.next!.next)
}

private func deleteMiddleNode(_ head: inout Node?) {
    var numTotal = 0
    var level = -1
    guard var head = head else { return }
    deleteMiddleNodeRec(&head, numTotal: &numTotal, level: &level)
}

private func deleteMiddleNodeRec(_ head: inout Node, numTotal: inout Int, level: inout Int) {
    if head.next == nil {
        numTotal += 1
        level = 0
        return
    }
    
    numTotal += 1
    deleteMiddleNodeRec(&head.next!, numTotal: &numTotal, level: &level)
    if level == numTotal / 2 {
        head.next = head.next!.next
    }
    level += 1
}

// MARK: 2.2 kth to last
private func kthToLast(_ head: Node?, k: Int) -> Node? {
    var result: Node? = nil
    kthToLastRec(head, k: k, result: &result)
    return result
}

private func kthToLastAdvanced(_ head: Node?, k: Int) -> Node? {
    var p1: Node? = head
    var p2: Node? = head
    
    var ind = 0
    while p2 != nil {
        if ind == k {
            break
        }
        p2 = p2?.next
        ind += 1
    }
    
    while p2 != nil {
        p2 = p2?.next
        if p2 != nil {
            p1 = p1?.next
        }
    }
    
    return p1
}

private func kthToLastWithoutRec(_ head: Node?, k: Int) -> Node? {
    var curNode: Node? = head
    var prevNode: Node? = nil
    var prevNode2: Node? = nil
    
    while curNode != nil {
        if prevNode != nil {
            prevNode?.next = prevNode2
        }
        prevNode2 = prevNode
        prevNode = curNode
        curNode = curNode?.next
    }
    
    curNode = prevNode
    prevNode?.next = prevNode2
    
    var ind = 0
    while curNode != nil {
        if ind == k { return curNode }
        
        ind += 1
        
        curNode = curNode?.next
    }
    
    return nil
}

private func kthToLastRec(_ cur: Node?, k: Int, result: inout Node?) -> Int {
    if cur == nil { return -1 }
    
    let nextNumber = kthToLastRec(cur?.next, k: k, result: &result)
    if nextNumber + 1 == k {
        result = cur
    }
    return nextNumber + 1
}

// MARK: 2.1 remove duplicates
private func removeDuplicates(head: Node?) -> Node? {
    let res: Node? = head
    var prev: Node? = head
    var cur: Node? = head?.next
    
    var nums: Set<Int> = [head!.val]
    
    while (cur != nil) {
        if !nums.contains(cur!.val) {
            nums.insert(cur!.val)
            prev = cur
        } else {
            prev?.next = cur?.next
        }
        cur = cur?.next
    }
    
    return res
}

private func removeDuplicatesWithoutCollection(head: Node?) -> Node? {
    let res: Node? = head
    var curOuter: Node? = head
    var curInner: Node? = head?.next
    var prevInner: Node? = head
    
    while (curOuter != nil) {
        curInner = curOuter?.next
        prevInner = curOuter
        while (curInner != nil) {
            if curOuter!.val == curInner!.val {
                prevInner?.next = curInner?.next
            }
            prevInner = curInner
            curInner = curInner?.next
        }
        curOuter = curOuter?.next
    }
    
    return res
}
