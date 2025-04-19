//
//  GameBoard.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/29.
//

import Foundation

enum Direction{
    case up
    case down
    case left
    case right
}

class GameBoard: Codable {
    var size: Int
    var score: Int
    var points: [[Int]]
    var step: Int
    var heightScore: Int
    
    init(size: Int = 4) {
        self.score = 0
        self.size = size
        self.points = [[Int]](repeating: [Int](repeating: 0, count: size), count: size)
        self.step = 0
        self.heightScore = 0
    }
    
    // Calculate total score
    func calculateTotalScore() {
        var currentScore = 0
        for i in 0..<size {
            for j in 0..<size {
                currentScore += points[i][j]
            }
        }
        score = currentScore
    }
    
    // Generate number randomly: 2 or 4
    func addRandomNumber(count: Int) {
        var addCount = count
        if addCount >= self.size*self.size { return }
        var zerosCount = 0
        for i in 0..<size {
            for j in 0..<size {
                if points[i][j] == 0 {
                    zerosCount += 1
                }
            }
        }
//        if addCount > zerosCount { addCount = 1 }
        if zerosCount == 1 {
            addCount = 1
        } else if addCount > zerosCount { return }
        for _ in 0..<addCount {
            let randomNumber = Int.random(in: 1...10)
            var flag: Bool = false
            var x: Int = 0
            var y: Int = 0
            while !flag {
                x = Int.random(in: 0..<4)
                y = Int.random(in: 0..<4)
                if self.points[x][y] == 0 {
                    flag = true
                }
            }
            if (randomNumber == 1 || randomNumber == 2) {
                self.points[x][y] = 4
            } else {
                self.points[x][y] = 2
            }
        }
    }
    
    // Check is over?
    func isOver() -> Bool {
        // 1.是否有空
        for i in 0..<size {
            for j in 0..<size {
                if points[i][j] == 0 {
                    return false
                }
            }
        }
        // 2.水平方向是否可合并
        for i in 0..<size {
            for j in 0..<size-1 {
                if points[i][j] == points[i][j+1] {
                    return false
                }
            }
        }
        // 3.竖直方向是否可合并
        for j in 0..<size {
            for i in 0..<size-1 {
                if points[i][j] == points[i+1][j] {
                    return false
                }
            }
        }
        return true
    }
    
    // Slide action
    func move(direction: Direction) {
        // 合并数字分为三步：1.移除空格 2.合并相邻数字 3.移除空格
        switch direction {
        case .left:
            for i in 0..<self.size {
                // 1.移除空格
                let nonZeroRow = points[i].filter { $0 != 0 }
                let zeros = Array(repeating: 0, count: size - nonZeroRow.count)
                points[i] = nonZeroRow + zeros
                // 2.合并数字
                for j in 0..<self.size-1 {
                    // 如果当前不为空且当前数字等于下一个数字则乘2
                    if points[i][j] != 0 && points[i][j] == points[i][j+1] {
                        points[i][j] *= 2
                        points[i][j+1] = 0
                    }
                }
                // 3.再次移除空格
                let nonZeroRowAfterEmerge = points[i].filter { $0 != 0 }
                let zerosAfterEmerge = Array(repeating: 0, count: size - nonZeroRowAfterEmerge.count)
                points[i] = nonZeroRowAfterEmerge + zerosAfterEmerge
            }
            break
        case .right:
            for i in 0..<size {
                // 1.
                let nonZeroRow = points[i].filter { $0 != 0 }
                let zeros = Array(repeating: 0, count: size - nonZeroRow.count)
                points[i] = zeros + nonZeroRow
                // 2.合并数字，先翻转成左对齐
                points[i] = points[i].reversed()
                for j in 0..<size-1 {
                    if points[i][j] != 0 && points[i][j] == points[i][j+1] {
                        points[i][j] *= 2
                        points[i][j+1] = 0
                    }
                }
                points[i] = points[i].reversed()
                // 3.
                let nonZeroRowAfterEmerge = points[i].filter { $0 != 0 }
                let zerosAfterEmerge = Array(repeating: 0, count: size - nonZeroRowAfterEmerge.count)
                points[i] = zerosAfterEmerge + nonZeroRowAfterEmerge
            }
            break
        case .up:
            // 1.提取数组
            for j in 0..<size {
                var col = [Int]()
                for i in 0..<size {
                    col.append(points[i][j])
                }
                // 2.移除空格
                let nonZeroCol = col.filter { $0 != 0 }
                let zeros = Array(repeating: 0, count: size-nonZeroCol.count)
                col = nonZeroCol + zeros
                // 3.合并相同数字
                for i in 0..<size-1 {
                    if col[i] != 0 && col[i] == col[i+1] {
                        col[i] *= 2
                        col[i+1] = 0
                    }
                }
                // 4.移除空格
                let nonZeroColAfterEmerge = col.filter { $0 != 0 }
                let zerosAfterEmerge = Array(repeating: 0, count: size-nonZeroColAfterEmerge.count)
                col = nonZeroColAfterEmerge + zerosAfterEmerge
                // 5.还原
                for i in 0..<size {
                    points[i][j] = col[i]
                }
            }
            break
        case .down:
            // 1.提取数组
            for j in 0..<size {
                var col = [Int]()
                for i in 0..<size {
                    col.append(points[i][j])
                }
                col = col.reversed()
                // 2.移除空格
                let nonZeroCol = col.filter { $0 != 0 }
                let zeros = Array(repeating: 0, count: size-nonZeroCol.count)
                col = nonZeroCol + zeros
                // 3.合并相同数字
                for i in 0..<size-1 {
                    if col[i] != 0 && col[i] == col[i+1] {
                        col[i] *= 2
                        col[i+1] = 0
                    }
                }
                // 4.移除空格
                let nonZeroColAfterEmerge = col.filter { $0 != 0 }
                let zerosAfterEmerge = Array(repeating: 0, count: size-nonZeroColAfterEmerge.count)
                col = nonZeroColAfterEmerge + zerosAfterEmerge
                // 5.还原
                col = col.reversed()
                for i in 0..<size {
                    points[i][j] = col[i]
                }
            }
            break
        }
        step += 1
    }
    
    // Print board
    func printBoard() {
        print(self.points)
    }
}
