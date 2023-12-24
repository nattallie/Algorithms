import Foundation

// MARK: - Chapter 4: Trees & Graphs

// MARK: Node
class Node {
    var val: Int
    var left: Node?
    var right: Node?
    var parent: Node?
    var size: Int?
    
    init(val: Int, left: Node? = nil, right: Node? = nil, parent: Node? = nil, size: Int? = 0) {
        self.val = val
        self.left = left
        self.right = right
        self.parent = parent
        self.size = size
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

// MARK: 4.12 Paths with Sum
func pathWithSums(root: Node?, target: Int) -> Int {
    var numOfPaths: Int = 0
    var runningSums: [Int: Int] = [:]
    pathWithSumsRec(root: root, target: target, res: &numOfPaths, soFar: 0, runningSums: &runningSums)
    return numOfPaths
}

private func pathWithSumsRec(root: Node?, target: Int, res: inout Int, soFar: Int, runningSums: inout [Int: Int]) {
    guard let root = root else { return }
    
    let newSoFar = soFar + root.val
    
    if newSoFar == target {
        res += 1
    }
    
    if let numOfLeftover = runningSums[newSoFar-target] {
        res += numOfLeftover
    }
    
    runningSums[newSoFar] = runningSums[newSoFar, default: 0] + 1
    pathWithSumsRec(root: root.left, target: target, res: &res, soFar: newSoFar, runningSums: &runningSums)
    pathWithSumsRec(root: root.right, target: target, res: &res, soFar: newSoFar, runningSums: &runningSums)
    runningSums[newSoFar] = runningSums[newSoFar, default: 1] - 1
}

//let node9 = Node(val: -2)
//let node8 = Node(val: 3)
//let node1 = Node(val: 3, left: node8, right: node9)
//let node4 = Node(val: 2)
//let node2 = Node(val: 1, right: node4)
//let node3 = Node(val: 5, left: node1, right: node2)
//let node5 = Node(val: 11)
//let node7 = Node(val: -3, right: node5)
//let root = Node(val: 10, left: node3, right: node7)
//
//print(pathWithSums(root: root, target: 8))

// MARK: 4.11 Binary Tree
class BinaryTree {
    private var root: Node? = nil
    
    init() {}
    
    func insert(val: Int) {
        let (parent, node) = findWithParent(parent: nil, curNode: root, val: val, shouldIncreaseSize: true)
        // this insertion wouldn't work for duplicates
        guard node == nil else { return }
        
        if parent == nil {
            root = .init(val: val)
        } else if parent!.val < val {
            parent!.right = .init(val: val)
        } else {
            parent!.left = .init(val: val)
        }
    }
    
    func find(val: Int) -> Node? {
        let (_, node) = findWithParent(parent: nil, curNode: root, val: val, shouldIncreaseSize: false)
        return node
    }
    
    private func findWithParent(parent: Node?, curNode: Node?, val: Int, shouldIncreaseSize: Bool) -> (Node?, Node?) {
        if curNode == nil || curNode?.val == val { return (parent, curNode) }
        
        if shouldIncreaseSize {
            curNode!.size = (curNode?.size ?? 0) + 1
        }

        if val > curNode!.val {
            return findWithParent(parent: curNode, curNode: curNode?.right, val: val, shouldIncreaseSize: shouldIncreaseSize)
        } else {
            return findWithParent(parent: curNode, curNode: curNode?.left, val: val, shouldIncreaseSize: shouldIncreaseSize)
        }
    }
    
    func getRandomNode() -> Node? {
        guard let root = root, let size = root.size, size > 0 else { return root }
        
        let randomIndex = Int.random(in: 0...size)
        print("random index was: \(randomIndex)")
        return getRandomNodeRec(curNode: root, index: randomIndex)
    }
    
    private func getRandomNodeRec(curNode: Node?, index: Int) -> Node? {
        guard let curNode = curNode, let size = curNode.size, size > 0 else { return curNode }
        
        let leftSize = curNode.left == nil ? -1 : (curNode.left?.size ?? 0)
        
        if index <= leftSize {
            return getRandomNodeRec(curNode: curNode.left, index: index)
        } else if index == leftSize + 1 {
            return curNode
        } else {
            return getRandomNodeRec(curNode: curNode.right, index: size - index)
        }
    }
    
    func logTree() -> [(Int, Int)] {
        var result: [(Int, Int)] = []
        treeTraversal(root: root, &result)
        return result
    }
    
    private func treeTraversal(root: Node?, _ numbers: inout [(Int, Int)]) {
        guard let root = root else { return }
        
        treeTraversal(root: root.left, &numbers)
        numbers.append((root.val, root.size ?? 0))
        treeTraversal(root: root.right, &numbers)
    }
}

//let binaryTree: BinaryTree = .init()
//binaryTree.insert(val: 20)
//binaryTree.insert(val: 13)
//binaryTree.insert(val: 6)
//binaryTree.insert(val: 10)
//binaryTree.insert(val: 15)
//binaryTree.insert(val: 14)
//binaryTree.insert(val: 18)
//binaryTree.insert(val: 30)
//binaryTree.insert(val: 25)
//binaryTree.insert(val: 38)
//binaryTree.insert(val: 36)
//print(binaryTree.logTree())
//print(binaryTree.getRandomNode()?.val)

// MARK: 4.10 Subtree
private func checkSubtree(_ root1: Node?, _ root2: Node?) -> Bool {
    checkSubtreeRec(root1, curRoot1: root1, root2, curRoot2: root2)
}

private func checkSubtreeRec(_ root1: Node?, curRoot1: Node?, _ root2: Node?, curRoot2: Node?) -> Bool {
    if curRoot2 == nil { return true }
    if curRoot1 == nil { return false }
    
    if curRoot1?.val == curRoot2?.val {
        let newRoot1 = curRoot2 === root2 ? curRoot1 : root1
        return checkSubtreeRec(newRoot1, curRoot1: curRoot1?.left, root2, curRoot2: curRoot2?.left) &&
            checkSubtreeRec(newRoot1, curRoot1: curRoot1?.right, root2, curRoot2: curRoot2?.right)
    } else {
        return checkSubtreeRec(root1, curRoot1: root1?.left, root2, curRoot2: curRoot2) ||
            checkSubtreeRec(root1, curRoot1: root1?.right, root2, curRoot2: curRoot2)
    }
}

// MARK: 4.9 BST Sequences
private func sequences(root: Node?) -> [[Int]] {
    guard root != nil else { return [] }
    
    let left = sequences(root: root?.left)
    
    let right = sequences(root: root?.right)
    
    var result: [[Int]] = []
    
    if left.isEmpty && right.isEmpty {
        return [[root!.val]]
    } else if left.isEmpty || right.isEmpty {
        let toBeProcessed = left.isEmpty ? right : left
        var weaved: [[Int]] = .init()
        for l in toBeProcessed {
            weaveSequences(l1: l, l2: [], l1Ind: 0, l2Ind: 0, soFar: [], result: &weaved)
        }
        
        weaved.forEach {
            var first = [root!.val]
            first.append(contentsOf: $0)
            result.append(first)
        }
    } else {
        var weaved: [[Int]] = .init()
        for l1 in left {
            for l2 in right {
                weaveSequences(l1: l1, l2: l2, l1Ind: 0, l2Ind: 0, soFar: [], result: &weaved)
            }
        }
        
        weaved.forEach {
            var first = [root!.val]
            first.append(contentsOf: $0)
            result.append(first)
        }
    }
    
    return result
}

private func weaveSequences(l1: [Int], l2: [Int], l1Ind: Int, l2Ind: Int, soFar: [Int], result: inout [[Int]]) {
    if soFar.count == l1.count + l2.count {
        result.append(soFar)
        return
    }

    if l1Ind >= l1.count && l2Ind >= l2.count { return }
    
    for i in l1Ind..<l1.count {
        for j in l2Ind..<l2.count {
            weaveSequences(l1: l1, l2: l2, l1Ind: i+1, l2Ind: j, soFar: soFar + [l1[i]], result: &result)
            weaveSequences(l1: l1, l2: l2, l1Ind: i, l2Ind: j+1, soFar: soFar + [l2[j]], result: &result)
        }
    }
    
    if l1Ind >= l1.count {
        for j in l2Ind..<l2.count {
            weaveSequences(l1: l1, l2: l2, l1Ind: l1Ind, l2Ind: j+1, soFar: soFar + [l2[j]], result: &result)
        }
    }
    
    if l2Ind >= l2.count {
        for i in l1Ind..<l1.count {
            weaveSequences(l1: l1, l2: l2, l1Ind: i+1, l2Ind: l2Ind, soFar: soFar + [l1[i]], result: &result)
        }
    }
}


//let node3 = Node(val: 25)
//let node6 = Node(val: 67)
//let node7 = Node(val: 77, left: node6)
//let root = Node(val: 50, left: node3, right: node7)
//
//print(sequences(root: root))


// MARK: 4.8 First Common Ancestor
private func fca(root: Node?, n1: Node?, n2: Node?) -> Node? {
    if root == nil || root === n1 || root === n2 { return root }
    
    let leftSide = fca(root: root?.left, n1: n1, n2: n2)
    
    if leftSide != nil && leftSide !== n1 && leftSide !== n2 {
        return leftSide
    }
    
    let rightSide = fca(root: root?.right, n1: n1, n2: n2)
    if rightSide != nil && rightSide !== n1 && rightSide !== n2 {
        return rightSide
    }
    
    if leftSide != nil && rightSide != nil {
        return root
    } else if leftSide != nil {
        return leftSide
    } else {
        return rightSide
    }
}

//let node1 = Node(val: 20)
//let node2 = Node(val: 51)
//let node3 = Node(val: 25, left: node1, right: node2)
//let node4 = Node(val: 202)
//let node8 = Node(val: 100)
//let node5 = Node(val: 200, left: node8, right: node4)
//let node6 = Node(val: 67)
//let node7 = Node(val: 77, left: node6, right: node5)
//let root = Node(val: 50, left: node3, right: node7)
//
//print(fca(root: node6, n1: node6, n2: node6)?.val)

// MARK: 4.7 Build Order
private func buildOrder(projects: [Character], dependencies: [(Character, Character)]) -> [Character] {
    var graph: [Character: [Character]] = [:]
    
    for project in projects {
        graph[project] = []
    }
    
    for dep in dependencies {
        graph[dep.0]?.append(dep.1)
    }
    
    var visited: [Character] = []
    while visited.count < projects.count {
        for proj in graph.keys {
            if graph[proj]!.isEmpty && !visited.contains(proj) {
                visited.append(proj)
                for i in graph.keys {
                    if graph[i]!.contains(proj) {
                        graph[i]?.removeAll(where: { $0 == proj })
                    }
                }
            }
        }
    }
    
    return visited.count == projects.count ? visited : []
}

//let projects: [Character] = ["a", "b", "c", "d", "e", "f"]
//let dependencies: [(Character, Character)] = [("a", "d"), ("f", "b"), ("b", "d"), ("f", "a"), ("d", "c")]
//print(buildOrder(projects: projects, dependencies: dependencies))

// MARK: 4.6 Print next node
private func nextNode(node: Node?) -> Int? {
    guard let node = node else { return -1 }
    
    if let rightNode = node.right, let deepestLeft = deepestLeft(node: rightNode) {
        return deepestLeft
    } else if var parent = node.parent {
        var curNode: Node? = node
        while parent.right === curNode {
            curNode = parent
            if let newParent = curNode?.parent {
                parent = newParent
            } else {
                return nil
            }
        }
        return parent.val
    } else {
        return nil
    }
}

private func deepestLeft(node: Node?) -> Int? {
    guard let node = node else { return nil }
    
    var leftNode: Node = node
    while let leftChild = leftNode.left {
        leftNode = leftChild
    }
    return leftNode.val
}

//let node1 = Node(val: 20)
//let node2 = Node(val: 51)
//let node3 = Node(val: 25, left: node1, right: node2)
//let node4 = Node(val: 202)
//let node8 = Node(val: 100)
//let node5 = Node(val: 200, left: node8, right: node4)
//let node6 = Node(val: 67)
//let node7 = Node(val: 77, left: node6, right: node5)
//let root = Node(val: 50, left: node3, right: node7)
//
//node3.parent = root
//node1.parent = node3
//node2.parent = node3
//node7.parent = root
//node6.parent = node7
//node5.parent = node7
//node8.parent = node5
//node4.parent = node5
//print(nextNode(node: node5))

// MARK: 4.5 Is binary search tree
private func isBinarySearchTree(root: Node?) -> Bool {
    return isBinaryRec(root: root, minLim: Int.min, maxLimit: Int.max)
}

private func isBinaryRec(root: Node?, minLim: Int, maxLimit: Int) -> Bool {
    if root == nil { return true }
    
    if root!.val < minLim || root!.val > maxLimit {
        return false
    }
    
    return isBinaryRec(root: root?.left, minLim: minLim, maxLimit: root!.val) &&
        isBinaryRec(root: root?.right, minLim: root!.val, maxLimit: maxLimit)
}

//let node1 = Node(val: 20)
//let node2 = Node(val: 51)
//let node3 = Node(val: 25, left: node1, right: node2)
//let node4 = Node(val: 202)
//let node8 = Node(val: 100)
//let node5 = Node(val: 200, left: node8, right: node4)
//let node6 = Node(val: 67)
//let node7 = Node(val: 77, left: node6, right: node5)
//let root = Node(val: 50, left: node3, right: node7)
//print(isBinarySearchTree(root: root))

// MARK: 4.4 Balance Check
private func isBalanced(root: Node?) -> Bool {
    var isBalanced: Bool = true
    checkHeight(root: root, &isBalanced)
    return isBalanced
}

private func checkHeight(root: Node?, _ isBalanced: inout Bool) -> Int {
    if root == nil { return 0 }
    if !isBalanced { return -1 }
    
    let left = checkHeight(root: root?.left, &isBalanced)
    if !isBalanced {
        return -1
    }
    
    let right = checkHeight(root: root?.right, &isBalanced)
    if !isBalanced {
        return -1
    }
    
    if abs(left-right) > 1 {
        isBalanced = false
        return -1
    } else {
        return max(left, right) + 1
    }
}


//let node9 = Node(val: 90)
//let node1 = Node(val: 3)//, left: node9)
//let node2 = Node(val: 10)
//let node3 = Node(val: 5, left: node1, right: node2)
//let node7 = Node(val: 28)
//let root = Node(val: 14, left: node3, right: node7)
//
//print(isBalanced(root: root))

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
