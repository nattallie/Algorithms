import Foundation

// MARK: - Chapter 5: Bits

// MARK: problem 5.8
private func drawLine(bytes: inout [Int8], width: Int, x1: Int, x2: Int, y: Int) {
    var bytesBinary: String = ""
    bytes.forEach {
        bytesBinary += $0.binaryDescription
    }
    
    let bitIndexStart: Int = x1 % 8
    let byteIndexStart: Int = (width / 8) * y + x1 / 8
    
    let bitIndexEnd: Int = x2 % 8
    let byteIndexEnd: Int = (width / 8) * y + x2 / 8
    
    
    let wholeByteStart: Int = bitIndexStart == 0 ? byteIndexStart : byteIndexStart + 1
    let wholeByteEnd: Int = bitIndexEnd == 7 ? byteIndexEnd : byteIndexEnd - 1
    
    print("bitIndexStart: \(bitIndexStart), byteIndexStart: \(byteIndexStart), bitIndexEnd: \(bitIndexEnd), byteIndexEnd: \(byteIndexEnd)")
    print("wholeByteStart: \(wholeByteStart), wholeByteEnd: \(wholeByteEnd)")
    
    if wholeByteStart <= wholeByteEnd {
        for i in wholeByteStart...wholeByteEnd {
            bytes[i] |= -1
        }
    }
    
    if byteIndexStart == byteIndexEnd {
        let mask: Int8 = ((1 << (8-bitIndexStart)) - 1) & (~((1 << (8-bitIndexEnd-1)) - 1))
        bytes[byteIndexStart] |= mask
    } else {
        if bitIndexStart != 0 {
            bytes[byteIndexStart] |= ((1 << (8-bitIndexStart)) - 1)
        }
        
        if bitIndexEnd != 7 {
            bytes[byteIndexEnd] |= ~((1 << (8-bitIndexEnd-1)) - 1)
        }
    }
}

// MARK: problem 5.7
private func swapBits(_ num: Int) -> Int {
    var res: Int = 0
    print(num.binaryDescription)
    var mask: Int = 0
    
    for i in 0..<32 {
        if i % 2 == 0 {
            mask |= 1 << i
        }
    }
    
    print("odd mask \(mask.binaryDescription)")
    res |= (num & mask) << 1
    print("odd bits \(res.binaryDescription)")
    mask >>= 1
    mask |= (1 << 31)
    print("even mask \(mask.binaryDescription)")
    
    res |= (num & mask) >> 1

    return res
}

// MARK: problem 5.6
private func conversion(a: Int, b: Int) -> Int {
    var res: Int = 0
    var xored = a ^ b
    
    print(a.binaryDescription)
    print(b.binaryDescription)
    
    while xored != 0 {
        if xored & 1 != 0 {
            res += 1
        }
        xored >>= 1
    }
    return res
}

// MARK: problem 5.5
// key point: is the number power of two

// MARK: problem 5.4 nextNumber
private func printNextSmallestNextLargest(_ num: Int) {
    print(num.binaryDescription)
    var rightZero: Int = 0
    var hasSeenOne: Bool = false
    
    for i in 0..<32 {
        if !hasSeenOne && (num & (1 << i) == 1) {
           hasSeenOne = true
        }
        if (num & (1 << i) == 0) && hasSeenOne {
            rightZero = i
            break
        }
    }

    print(rightZero, "right zero")
    let mask: Int = ~(1 << (rightZero - 1))
    let nextSmallest: Int = (num | (1 << rightZero)) & mask
    print("next smallest \(nextSmallest.binaryDescription)")
        
    
    var leftZero: Int = 0
    for i in 0..<32 {
        if num & (1 << i) == 0 {
            leftZero = i
        }
    }
    print(leftZero, "leftZero")
    
    var nextLargest: Int = num | (1 << leftZero)
    for i in 0...leftZero {
        if num & (1 << i) == 1 {
            nextLargest = nextLargest & (~(1<<i))
            break
        }
    }
    print("next largest \(nextLargest.binaryDescription)")
}

// MARK: problem 5.3 flip bit to win
private func flipBitToWin(n: Int) -> Int {
    var zeroIndices: [Int] = [-1]
    
    for i in 0...31 {
        if (1 << i) & n == 0 {
            zeroIndices.append(i)
        }
    }
    
    zeroIndices.append(32)
    var res: Int = 0
    for i in 1..<zeroIndices.count - 1 {
        res = max(res, zeroIndices[i+1] - zeroIndices[i-1] - 1)
    }
    
    return res
}

private func flipBitToWinBetter(n: Int) -> Int {
    var res: Int = 0
    var num: Int = n
    var cur: Int = 0
    var prev: Int = 0
    
    if ~num == 0 { return 32 }
    
    while num != 0 {
        if num & 1 == 0 {
            if num & 2 == 0 {
                prev = 0
            } else {
                prev = cur
            }
            cur = 0
        } else {
            cur += 1
        }
        res = max(res, prev + cur + 1)
        num >>= 1
    }
    return res
}

// MARK: problem 5.2 binary to string
private func BinaryToString(n: Double) -> String {
    if n >= 1.0 || n < 0.0 {
        return "ERROR"
    }
    
    var result = "."
    var nCopy = n
    while nCopy > 0 {
        if result.count >= 32 {
            return "ERROR"
        }
        nCopy *= 2
        if nCopy >= 1 {
            nCopy -= 1
            result += "1"
        } else {
            result += "0"
        }
    }
    
    return result
}

// MARK: problem 5.1 - insertion
private func insertion(n: Int, m: Int, i: Int, j: Int) -> Int {
    let leftMask: Int = ~((1 << (j+1)) - 1)
    print(printBinary(leftMask), "leftMask", leftMask.binaryDescription)
    let rightMask: Int = (1 << i) - 1
    print(printBinary(rightMask), "rightMask", rightMask.binaryDescription)
    let onesMask: Int = leftMask | rightMask
    print(printBinary(onesMask), "onesMask", onesMask.binaryDescription)
    let shiftedM: Int = m << i
    print(printBinary(shiftedM), "shiftedM", shiftedM.binaryDescription)
    return (n & onesMask) | shiftedM
}

extension BinaryInteger {
    var binaryDescription: String {
        var binaryString = ""
        var internalNumber = self
        var counter = 0

        for _ in (1...self.bitWidth) {
            binaryString.insert(contentsOf: "\(internalNumber & 1)", at: binaryString.startIndex)
            internalNumber >>= 1
            counter += 1
            if counter % 4 == 0 {
                binaryString.insert(contentsOf: " ", at: binaryString.startIndex)
            }
        }

        return binaryString
    }
}

private func printBinary(_ num: Int) -> String {
    return String(num, radix: 2)
}
