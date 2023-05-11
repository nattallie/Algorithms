import Foundation

// MARK: - Chapter 4: Trees & Graphs

// MARK: Node
class Node {
    var val: Int
    var left: Node?
    var right: Node?
    
    init(val: Int, left: Node? = nil, right: Node? = nil) {
        self.val = val
        self.left = left
        self.right = right
    }
}

// helper functions
private func treeTraversal(root: Node?) {
    guard let root = root else { return }
    
    treeTraversal(root: root.left)
    print(root.val)
    treeTraversal(root: root.right)
}

private func treeDepth(root: Node?) -> Int {
    guard let root = root else { return 0 }
    
    return max(treeDepth(root: root.left) + 1, treeDepth(root: root.right) + 1)
}

// MARK: 4.3 List of Depths
private func listOfDepths(root: Node?) -> [Node] {
    var nodeDict: [Int: Node] = [:]
    
    traverseTreeAndFillDepthNodes(depth: 0, root, &nodeDict)
    
    var curDepth = 0
    var res: [Node] = []
    
    while nodeDict[curDepth] != nil {
        res.append(nodeDict[curDepth]!)
        curDepth += 1
    }
    
    return res
}

private func traverseTreeAndFillDepthNodes(depth: Int, _ node: Node?, _ nodeDict: inout [Int: Node]) {
    guard let node = node else { return }
    
    traverseTreeAndFillDepthNodes(depth: depth + 1, node.right, &nodeDict)
    let newNode = Node(val: node.val)
    if nodeDict[depth] != nil {
        let prev = nodeDict[depth]!
        newNode.right = prev
    }
    nodeDict[depth] = newNode
    traverseTreeAndFillDepthNodes(depth: depth + 1, node.left, &nodeDict)
}

//let node1 = Node(val: 3)
//let node2 = Node(val: 10)
//let node3 = Node(val: 5, left: node1, right: node2)
//let node4 = Node(val: 30)
//let node5 = Node(val: 29, right: node4)
//let node6 = Node(val: 24)
//let node7 = Node(val: 28, left: node6, right: node5)
//let root = Node(val: 14, left: node3, right: node7)
//
//let depthNodes = listOfDepths(root: root)
//
//for i in 0..<depthNodes.count {
//    print("depth is \(i)")
//    var node = depthNodes[i]
//    print(node.val)
//    while node.right != nil {
//        node = node.right!
//        print(node.val)
//    }
//}

// MARK: 4.2 Minimal Tree
private func minimalTree(nums: [Int]) -> Node {
    var root: Node = .init(val: -1)
    buildMinimalTree(root, lp: 0, rp: nums.count - 1, nums: nums)
    return root
}

private func buildMinimalTree(_ node: Node, lp: Int, rp: Int, nums: [Int]) {
    let midInd = (lp+rp)/2
    node.val = nums[midInd]
    if midInd > lp {
        node.left = .init(val: -1)
        buildMinimalTree(node.left!, lp: lp, rp: midInd-1, nums: nums)
    }
    
    if midInd < rp {
        node.right = .init(val: -1)
        buildMinimalTree(node.right!, lp: midInd+1, rp: rp, nums: nums)
    }
}

//let root = minimalTree(nums: [3,5,10,14,24,28,29,30])
//treeTraversal(root: root)
//print(treeDepth(root: root))

// MARK: 4.1 Route between nodes
private func isRoad(n1: Int, n2: Int, graph: [[Bool]], visited: inout Set<Int>) -> Bool {
    for i in 0..<graph.count {
        if i == n1 { continue }
        
        if n1 == n2 { return true }
        
        if graph[n1][i] && !visited.contains(i) {
            visited.insert(i)
            if isRoad(n1: i, n2: n2, graph: graph, visited: &visited) {
                return true
            }
            visited.remove(i)
        }
    }
    
    return false
}

//var visited: Set<Int> = .init()
//let graph: [[Bool]] = [
//    [false, true, false, true, false, false, false],
//    [false, false, true, false, true, true, false],
//    [false, false, false, false, false, false, false],
//    [false, false, false, false, false, false, false],
//    [false, false, true, false, false, false, false],
//    [false, false, false, false, false, false, true],
//    [false, false, false, false, false, false, false]
//]

//print(isRoad(n1: 0, n2: 4, graph: graph, visited: &visited))
