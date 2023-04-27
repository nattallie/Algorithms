import Foundation

// MARK: - Chapter 1: Arrays & Strings

// MARK: 1.9 isRotation
private func isRotationAdvanced(_ s1: String, _ s2: String) -> Bool {
    return (s2+s2).contains(s1)
}

private func isRotation(_ s1: String, _ s2: String) -> Bool {
    guard s1.count == s2.count else { return false }
    
    let s1Array: [Character] = .init(s1)
    let s2Array: [Character] = .init(s2)
    
    var firstPtr: Int = 0
    while firstPtr < s1Array.count {
        while s1Array[firstPtr] != s2Array[0] {
            firstPtr += 1
            if firstPtr >= s1Array.count { return false }
        }
        
        if
            s1Array[0..<firstPtr] == s2Array[s2Array.count-firstPtr..<s2Array.count] &&
            s1Array[firstPtr..<s1Array.count] == s2Array[0..<s2Array.count-firstPtr]
        {
            return true
        }
        firstPtr += 1
    }
    return false
}

// MARK: 1.8 zerofication
private func zerofy(_ m: inout [[Int]]) {
    var firstRowIndicator: Bool = false
    var firstColIndicator: Bool = false
    
    for j in 0..<m.first!.count {
        if m[0][j] == 0 {
            firstRowIndicator = true
            break
        }
    }

    for i in 0..<m.count {
        if m[i][0] == 0 {
            firstColIndicator = true
            break
        }
    }

    for i in 1..<m.count {
        for j in 1..<m.first!.count {
            if m[i][j] == 0 {
                m[0][j] = 0
                m[i][0] = 0
            }
        }
    }

    for i in 1..<m.count {
        for j in 1..<m.first!.count {
            if m[i][0] == 0 || m[0][j] == 0 {
                m[i][j] = 0
            }
        }
    }

    if firstRowIndicator {
        for j in 0..<m.first!.count {
            m[0][j] = 0
        }
    }

    if firstColIndicator {
        for i in 0..<m.count {
            m[i][0] = 0
        }
    }
}

// MARK: 1.7 rotate matrix
private func rotateMatrix(_ m: [[Int]]) -> [[Int]] {
    var newMatrix: [[Int]] = .init(repeating: .init(repeating: 0, count: m.count), count: m.count)
    
    for i in 0..<m.count {
        for j in 0..<m.count {
            newMatrix[j][m.count-i-1] = m[i][j]
        }
    }
    
    return newMatrix
}

private func rotateMatrixAdvanced(_ m: inout [[Int]]) {
    var tmp: Int
    for i in 0..<m.count-1 {
        if i >= m.count-i-1 { break }
        for j in i..<m.count-i-1 {
            // old version
//            tmp = m[i][j]
//            m[i][j] = m[j][m.count-i-1]
//            m[j][m.count-i-1] = tmp
//
//            tmp = m[i][j]
//            m[i][j] = m[m.count-i-1][m.count-j-1]
//            m[m.count-i-1][m.count-j-1] = tmp
//
//            tmp = m[i][j]
//            m[i][j] = m[m.count-j-1][i]
//            m[m.count-j-1][i] = tmp
            
            // better version
            tmp = m[j][m.count-i-1]
            m[j][m.count-i-1] = m[i][j]
            m[i][j] = m[m.count-j-1][i]
            m[m.count-j-1][i] = m[m.count-i-1][m.count-j-1]
            m[m.count-i-1][m.count-j-1] = tmp
        }
    }
}

// MARK: 1.6 string compression
private func stringCompression(_ s: String) -> String {
    guard !s.isEmpty else { return "" }
    
    let sortedString: [Character] = .init(s.sorted())
    var newString = ""
    var curChar: Character = sortedString.first!
    var cnt = 1
    
    for i in 1..<sortedString.count {
        if sortedString[i] != curChar {
            newString += "\(curChar)\(cnt)"
            curChar = sortedString[i]
            cnt = 1
        } else {
            cnt += 1
        }
    }
    newString += "\(curChar)\(cnt)"
    
    return newString.count < s.count ? newString : s
}

// MARK: 1.5 one step away
private func oneStepAway(_ s1: String, _ s2: String) -> Bool {
    guard abs(s1.count - s2.count) <= 1 else { return false }
    
    if s1.count > s2.count {
        return oneStepAwayHelper(s1, s2)
    } else {
        return oneStepAwayHelper(s2, s1)
    }
}

private func oneStepAwayHelper(_ longer: String, _ shorter: String) -> Bool {
    let longerArray: [Character] = .init(longer)
    let shorterArray: [Character] = .init(shorter)
    
    for i in 0..<shorter.count {
        if longerArray[i] != shorterArray[i] {
            return
                longerArray[i+1..<longer.count] == shorterArray[i+1..<shorter.count] ||
                longerArray[i+1..<longer.count] == shorterArray[i..<shorter.count]
        }
    }
    
    return true
}

// MARK: 1.4 is permutation of palindrome
private func isPermutationOfPalindrome(_ s: String) -> Bool {
    var freq: [Character: Int] = [:]
    
    var numberOfOdds = 0
    Array(s.lowercased()).forEach {
        if !$0.isWhitespace {
            freq[$0, default: 0] += 1
            if freq[$0, default: 0] % 2 != 0 {
                numberOfOdds += 1
            } else {
                numberOfOdds -= 1
            }
        }
    }
    
    return numberOfOdds <= 1
}

private func isPermutationOfPalindromeBit(_ s: String) -> Bool {
    var numberOfOdds = 0
    
    var mask = 0
    Array(s.lowercased()).forEach {
        if !$0.isWhitespace {
            mask = 1 << (Int($0.asciiValue! - Character("a").asciiValue!))
            if numberOfOdds & mask == 0 {
                numberOfOdds |= mask
            } else {
                numberOfOdds &= ~mask
            }
        }
    }

    return (numberOfOdds == 0) || ((numberOfOdds - 1) & numberOfOdds == 0)
}

// MARK: 1.3 URLify
private func urlify(_ s: String, length: Int) -> String {
    let tokens: [Substring] = s.split(separator: " ")
    return tokens.joined(separator: "%20")
}

private func urlifyModified(_ s: String, length: Int) -> String {
    var resultString: [Character] = .init(s)
    
    var curInd = s.count - 1
    for i in (0..<length).reversed() {
        if !resultString[i].isWhitespace {
            resultString[curInd] = resultString[i]
            curInd -= 1
        } else {
            resultString[curInd] = .init("0")
            resultString[curInd-1] = .init("2")
            resultString[curInd-2] = .init("%")
            curInd -= 3
        }
    }
    
    return String(resultString)
}

// MARK: 1.2
private func isPermutation(_ s1: String, _ s2: String) -> Bool {
    guard s1.count == s2.count else { return false }
    
    for (a, b) in zip(s1.sorted(), s2.sorted()) {
        if a != b {
            return false
        }
    }
    
    return true
}

private func isPermutationFrequences(_ s1: String, _ s2: String) -> Bool {
    guard s1.count == s2.count else { return false }
    
    var freq: [Int] = .init(repeating: 0, count: 128)
    Array(s1).forEach {
        freq[Int($0.asciiValue!)] += 1
    }
    
    let s2Chars: [Character] = .init(s2)
    for i in 0..<s2Chars.count {
        freq[Int(s2Chars[i].asciiValue!)] -= 1
        if freq[Int(s2Chars[i].asciiValue!)] < 0 {
            return false
        }
    }
    
    return true
}

// MARK: 1.1 isUnique
private func isUnique(_ word: String) -> Bool {
    var freq: [Bool] = .init(repeating: false, count: 128)
    let charArray: [Character] = .init(word)
    
    for i in 0..<charArray.count {
        if freq[Int(charArray[i].asciiValue! - Character("a").asciiValue!)] {
            return false
        }
        freq[Int(charArray[i].asciiValue! - Character("a").asciiValue!)] = true
    }
    
    return true
}

private func isUniqueWithoutCollection(_ word: String) -> Bool {
    let charArray: [Character] = .init(word.lowercased())
    
    var res: Int = 0
    var curBit: Int = 0
    for i in 0..<charArray.count {
        curBit = 1 << Int((charArray[i].asciiValue ?? 0) - (Character("a").asciiValue ?? 0))
        if res & curBit > 0 {
            return false
        }
        res |= curBit
    }
    
    return true
}
