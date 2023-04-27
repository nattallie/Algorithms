import Foundation

// MARK: - Chapter 8: Recursion and Dynamic Programming

// MARK: problem 8.14 boolean evaluation
struct Expression: Hashable {
    let exp: String
    let val: Int
}

private func evaluateNumberOfWays(_ expression: String, _ value: Bool) -> Int {
    var dict: [Expression : Int] = [:]
    return evaluateRec(.init(expression), value ? 1 : 0, ind: 0, dict: &dict)
}

private func evaluateRec(_ expression: [Character], _ value: Int, ind: Int, dict: inout [Expression : Int]) -> Int {
    if ind >= expression.count {
        return 0
    }
    
    if ind == expression.count - 1 {
        return ((expression[ind] == "1" && value == 1) || (expression[ind] == "0" && value == 0)) ? 1 : 0
    }
    
    if expression[ind] == "1" || expression[ind] == "0" {
        return evaluateRec(expression, value, ind: ind + 1, dict: &dict)
    } else {
        let left: String = String(expression[0..<ind])
        let right: String = String(expression[ind+1..<expression.count])
        var leftCount0: Int = valueWrapper(left, 0, dict: &dict)
        var leftCount1: Int = valueWrapper(left, 1, dict: &dict)
        var rightCount0: Int = valueWrapper(right, 0, dict: &dict)
        var rightCount1: Int = valueWrapper(right, 1, dict: &dict)
        var res: Int = 0
        
        switch expression[ind] {
        case "&":
            if value == 0 {
                res = leftCount0 * rightCount1 + leftCount1 * rightCount0 + leftCount0 * rightCount0
            } else {
                res = leftCount1 * rightCount1
            }
        case "|":
            if value == 0 {
                res = leftCount0 * rightCount0
            } else {
                res = leftCount0 * rightCount1 + leftCount1 + rightCount0 + leftCount1 * rightCount1
            }
        case "^":
            if value == 0 {
                res = leftCount0 * rightCount0 + leftCount1 * rightCount1
            } else {
                res = leftCount0 * rightCount1 + leftCount1 * rightCount0
            }
        default:
            res = 0
        }
        
        dict[Expression(exp: String(expression), val: value)] = res
        return res
    }
}

private func valueWrapper(_ exp: String, _ val: Int, dict: inout [Expression : Int]) -> Int {
    if dict.keys.contains(Expression(exp: exp, val: val)) {
        return dict[Expression(exp: exp, val: val)]!
    } else {
        let count = evaluateRec(.init(exp), val, ind: 0, dict: &dict)
        dict[Expression(exp: exp, val: val)] = count
        return count
    }
}

// MARK: problem 8.13 boxes
private func generateNewPermutationWithItem(
    _ curInd: Int,
    at index: Int,
    oldPerm: [Int],
    newPermutations: inout [[Int]],
    maxHeight: inout Int,
    heights: [Int]
) {
    var generated = oldPerm
    generated.insert(curInd, at: index)
    newPermutations.append(generated)
    maxHeight = max(maxHeight, generated.map{heights[$0]}.reduce(0, +))
}

private func maxHeightBoxes(w: [Int], h: [Int], d: [Int], curInd: Int, res: inout [[Int]], maxHeight: inout Int) {
    if curInd >= w.count {
        res.append([])
        return
    }
    
    var newPermutations: [[Int]] = []
    
    maxHeightBoxes(w: w, h: h, d: d, curInd: curInd + 1, res: &res, maxHeight: &maxHeight)
    res.forEach { oldPerm in
        for i in 0...oldPerm.count {
            if oldPerm.isEmpty {
                generateNewPermutationWithItem(curInd, at: 0, oldPerm: oldPerm, newPermutations: &newPermutations, maxHeight: &maxHeight, heights: h)
            } else if i == 0 {
                if w[oldPerm[i]] > w[curInd] && h[oldPerm[i]] > h[curInd] && d[oldPerm[i]] > d[curInd] {
                    generateNewPermutationWithItem(curInd, at: i, oldPerm: oldPerm, newPermutations: &newPermutations, maxHeight: &maxHeight, heights: h)
                }
            } else if i == oldPerm.count {
                if w[oldPerm[i-1]] < w[curInd] && h[oldPerm[i-1]] < h[curInd] && d[oldPerm[i-1]] < d[curInd] {
                    generateNewPermutationWithItem(curInd, at: i, oldPerm: oldPerm, newPermutations: &newPermutations, maxHeight: &maxHeight, heights: h)
                }
            } else {
                if w[oldPerm[i-1]] < w[curInd] && h[oldPerm[i-1]] < h[curInd] && d[oldPerm[i-1]] < d[curInd] && w[oldPerm[i]] > w[curInd] && h[oldPerm[i]] > h[curInd] && d[oldPerm[i]] > d[curInd] {
                    generateNewPermutationWithItem(curInd, at: i, oldPerm: oldPerm, newPermutations: &newPermutations, maxHeight: &maxHeight, heights: h)
                }
            }
        }
    }
    res.append(contentsOf: newPermutations)
}

// MARK: problem 8.12 queens
private func isSafe(columns: [Int], row: Int, col: Int) -> Bool {
    for i in 0..<row {
        if columns[i] == col {
            return false
        }
        
        if abs(row-i) == abs(col-columns[i]) {
            return false
        }
    }
    
    return true
}

private func queens8(columns: inout [Int], rowInd: Int, counter: inout Int) {
    if rowInd == columns.count {
        counter += 1
        print(columns, counter)
        return
    }
    
    for col in 0..<columns.count {
        if isSafe(columns: columns, row: rowInd, col: col) {
            columns[rowInd] = col
            queens8(columns: &columns, rowInd: rowInd + 1, counter: &counter)
            columns[rowInd] = -1
        }
    }
}

private func isSafe(_ curBoard: inout [[Int]], _ i: Int, _ j: Int) -> Bool {
    for y in 0..<curBoard[0].count {
        if y == j { continue }
        if curBoard[i][y] == 1 {
            return false
        }
    }
    
    for y in 0..<curBoard.count {
        if y == i { continue }
        if curBoard[y][j] == 1 {
            return false
        }
    }
    
    for x in stride(from: i-1, through: 0, by: -1) {
        for y in stride(from: j-1, through: 0, by: -1) {
            if curBoard[x][y] == 1 {
                return false
            }
        }
    }
    
    for x in stride(from: i-1, through: 0, by: -1) {
        for y in stride(from: j+1, to: curBoard[0].count, by: 1) {
            if curBoard[x][y] == 1 {
                return false
            }
        }
    }
    
    for x in stride(from: i+1, to: curBoard.count, by: 1) {
        for y in stride(from: j-1, through: 0, by: -1) {
            if curBoard[x][y] == 1 {
                return false
            }
        }
    }
    
    for x in stride(from: i+1, to: curBoard.count, by: 1) {
        for y in stride(from: j+1, to: curBoard[0].count, by: 1) {
            if curBoard[x][y] == 1 {
                return false
            }
        }
    }
    
    return true
}

private func nQueens(n: Int, curBoard: inout [[Int]], res: inout [[[Int]]]) {
    if n == 0 {
        res.append(curBoard)
        return
    }
    
    for i in 0..<curBoard.count {
        for j in 0..<curBoard[0].count {
            if isSafe(&curBoard, i, j) {
                curBoard[i][j] = 1
                nQueens(n: n-1, curBoard: &curBoard, res: &res)
                curBoard[i][j] = 0
            }
        }
    }
}

// MARK: problem 8.11 coins

// MARK: problem 8.10 paintFill
private func paintFillRec(screen: inout [[Int]], row: Int, col: Int, resCol: Int, initCol: Int) {
    if row < 0 || row >= screen.count || col < 0 || col >= screen[0].count {
        return
    }
    
    if screen[row][col] == initCol {
        screen[row][col] = resCol
        paintFillRec(screen: &screen, row: row - 1, col: col, resCol: resCol, initCol: initCol)
        paintFillRec(screen: &screen, row: row + 1, col: col, resCol: resCol, initCol: initCol)
        paintFillRec(screen: &screen, row: row, col: col - 1, resCol: resCol, initCol: initCol)
        paintFillRec(screen: &screen, row: row, col: col + 1, resCol: resCol, initCol: initCol)
    }
}

private func paintFill(screen: inout [[Int]], row: Int, col: Int, resCol: Int) {
    paintFillRec(screen: &screen, row: row, col: col, resCol: resCol, initCol: screen[row][col])
}

// MARK: problem 8.9 parenthesis
private func generateNewPar(curRes: inout [Character], curInd: Int, numLeft: Int, numRight: Int, res: inout [[Character]]) {
    if numLeft < 0 || numRight < numLeft {
        return
    }
    
    if numLeft == 0 && numRight == 0 {
        res.append(curRes)
        return
    }
    
    curRes.append("(")
    generateNewPar(curRes: &curRes, curInd: curInd + 1, numLeft: numLeft - 1, numRight: numRight, res: &res)
    curRes.removeLast()
    
    curRes.append(")")
    generateNewPar(curRes: &curRes, curInd: curInd + 1, numLeft: numLeft, numRight: numRight - 1, res: &res)
    curRes.removeLast()
}

private func generateParenthesis(n: Int) -> [[Character]] {
    var res: [[Character]] = []
    var curRes: [Character] = []
    generateNewPar(curRes: &curRes, curInd: 0, numLeft: n, numRight: n, res: &res)
    return res
}

// MARK: problem 8.8 permutation - non unique
private func generatePermutationsNonUnique(prefix: inout [Character], freq: inout [Character: Int], length: Int, res: inout [[Character]]) {
    if prefix.count == length {
        res.append(prefix)
        return
    }
    
    freq.keys.forEach { ch in
        if freq[ch]! > 0 {
            freq[ch]! -= 1
            prefix.append(ch)
            generatePermutationsNonUnique(prefix: &prefix, freq: &freq, length: length, res: &res)
            prefix.removeLast()
            freq[ch]! += 1
        }
    }
}

private func getCharFreqs(_ s: [Character]) -> [Character: Int] {
    var freq: [Character: Int] = [:]
    
    s.forEach { ch in
        freq[ch, default: 0] += 1
    }
    
    return freq
}

private func generatePermutationsNonUnique(s: [Character]) -> [[Character]] {
    var prefix: [Character] = []
    var freq: [Character: Int] = getCharFreqs(s)
    var res: [[Character]] = []
    generatePermutationsNonUnique(prefix: &prefix, freq: &freq, length: s.count, res: &res)
    return res
}

// MARK: problem 8.7 permutation - unique
private func generatePermutations(s: [Character], ind: Int, res: inout [[Character]]) {
    if ind >= s.count {
        res.append([])
        return
    }
    
    generatePermutations(s: s, ind: ind + 1, res: &res)
    var permutationsIncludingCur: [[Character]] = []
    var curString: [Character] = []
    res.forEach { withoutChar in
        for i in 0...withoutChar.count {
            curString = withoutChar
            curString.insert(s[ind], at: i)
            permutationsIncludingCur.append(curString)
        }
    }
    res = permutationsIncludingCur
}

private func generatePermutations(s: inout [Character], res: inout [[Character]]) {
    if s.isEmpty {
        res.append([])
        return
    }
    
    let lastSym: Character = s.last!
    s.removeLast()
    generatePermutations(s: &s, res: &res)
    var permutationsIncludingCur: [[Character]] = []
    var curString: [Character] = []
    res.forEach { withoutChar in
        for i in 0...withoutChar.count {
            curString = withoutChar
            curString.insert(lastSym, at: i)
            permutationsIncludingCur.append(curString)
        }
    }
    res = permutationsIncludingCur
}

// MARK: problem 8.5 recursive multiply
private func recursiveMultiply(num1: Int, num2: Int) -> Int {
    if num2 == 0 {
        return 0
    }
    
    let cur: Int = (num2 & 1) == 1 ? num1 : 0
    return recursiveMultiply(num1: num1 << 1, num2: num2 >> 1) + cur
}

// MARK: problem 8.4 all subsets
private func generateAllSubsetsBit(numbers: [Int]) -> [[Int]] {
    var res: [[Int]] = []
    let max: Int = 1 << numbers.count
    for i in 0..<max {
        res.append(generateSub(numbers: numbers, num: i))
    }
    
    return res
}

private func generateSub(numbers: [Int], num: Int) -> [Int] {
    var res: [Int] = []
    var ind: Int = 0
    var cur: Int = num
    
    while cur > 0 {
        if cur & 1 == 1 {
            res.append(numbers[ind])
        }
        
        cur >>= 1
        ind += 1
    }
    
    return res
}

private func generateAllSubsets(numbers: [Int], result: inout [[Int]], curInd: Int, curSet: inout [Int]) {
    if curInd == numbers.count {
        result.append(curSet)
        return
    }
    
    generateAllSubsets(numbers: numbers, result: &result, curInd: curInd + 1, curSet: &curSet)
    curSet.append(numbers[curInd])
    generateAllSubsets(numbers: numbers, result: &result, curInd: curInd+1, curSet: &curSet)
    curSet.removeLast()
}

// MARK: problem 8.3 magic index
private func hasMagicIndexBinarySearchRec(numbers: [Int], start: Int, end: Int) -> Int {
    if start > end {
        return -1
    }
    
    let mid: Int = (start + end) / 2
    
    if numbers[mid] == mid {
        return mid
    }
    
    let leftIndex: Int = min(numbers[mid], mid - 1)
    let leftResult: Int = hasMagicIndexBinarySearchRec(numbers: numbers, start: start, end: leftIndex)
    if leftResult != -1 {
        return leftResult
    }
    
    let rightIndex: Int = max(mid + 1, numbers[mid])
    return hasMagicIndexBinarySearchRec(numbers: numbers, start: rightIndex, end: end)
}

private func hasMagicIndexBinarySearchNonDistinct(numbers: [Int]) -> Bool {
    return hasMagicIndexBinarySearchRec(numbers: numbers, start: 0, end: numbers.count - 1) != -1
}

private func hasMagicIndexBinarySearch(numbers: [Int]) -> Bool {
    var l: Int = 0
    var r: Int = numbers.count - 1
    var m: Int = (l+r) / 2
    
    while l <= r {
        if numbers[m] == m {
            return true
        }
        
        if numbers[m] < m {
            l = m + 1
        }
        
        if numbers[m] > m {
            r = m - 1
        }
        
        m = (l+r) / 2
    }
    
    return false
}

private func hasMagicIndex(numbers: [Int]) -> Bool {
    for i in 0..<numbers.count {
        if i == numbers[i] {
            return true
        }
        
        if numbers[i] > i {
            return false
        }
    }
    
    return false
}

// MARK: problem 8.2 robot In Grid
private func robotInGrid(grid: [[Int]], path: inout [(Int, Int)], row: Int, col: Int, visited: inout Set<Int>) -> Bool {
    if row >= grid.count || col >= grid[0].count || grid[row][col] == 1 || visited.contains(row*grid[0].count + col) {
        return false
    }
    
    if grid.count == row + 1 && grid[0].count == col + 1 {
        return true
    }
    
    path.append((row, col + 1))
    if robotInGrid(grid: grid, path: &path, row: row, col: col+1, visited: &visited) {
        return true
    }
    path.removeLast()
    path.append((row+1, col))
    if robotInGrid(grid: grid, path: &path, row: row + 1, col: col, visited: &visited) {
        return true
    }
    path.removeLast()
    
    visited.insert(row*grid[0].count + col)
    return false
}

// MARK: problem 8.1
private func tripleStep(_ n: Int) -> Int {
    var ways: [Int] = .init(repeating: 0, count: n)
    ways[0] = 1
    ways[1] = 1
    ways[2] = 1
    for i in 3..<n {
        ways[i] = ways[i-1] + ways[i-2] + ways[i-3]
    }
    return ways[n-1]
}
