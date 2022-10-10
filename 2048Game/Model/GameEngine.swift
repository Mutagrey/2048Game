//
//  GameEngine.swift
//  2048Game
//
//  Created by Sergey Petrov on 18.09.2022.
//

import SwiftUI

struct GameEngine: Codable {

    private static let startNumbers = [2, 2, 2, 4]
    
    private(set) var cells: [Cell] = []
    private(set) var moves: Int = 0
    private(set) var score: Int = 0
    private(set) var bestScore: Int = 0
    private(set) var bestMoves: Int = 0
    private(set) var rank: Int = 4
    private(set) var isGameOver: Bool = false
    private(set) var lastMove: Direction?
    
    enum Direction: String, Codable {
        case up
        case down
        case left
        case right
    }

    init(rank: Int){
        createNewGame(rank: rank)
    }
    
    // Reset Game
    mutating func createNewGame(rank: Int){
        self.rank = rank
        moves = 0
        score = 0
        cells = []
        isGameOver = false
        for _ in (0..<rank*rank){
            cells.append(.init())
        }
        cells[(0..<rank*rank).randomElement()!].number = 2
        cells[(0..<rank*rank).randomElement()!].number = GameEngine.startNumbers.randomElement()!
    }
    
    // Reset game best score
    mutating func resetBestScore() {
        bestScore = 0
        bestMoves = 0
    }

    /// Move Cell to Direction
    mutating func moveCell(to move: Direction) {
        self.lastMove = move
        let isSorted = self.sortCells(to: move)
        let isSum = self.sumCells(to: move)
        if isSorted || isSum {
            self.sortCells(to: move)    // Sort again after sum cells
            self.addNewCell()           // add new cell if we have empty cells
            self.moves += 1
            self.isGameOver = self.checkIsGameOver()
        }
    }
    
    // MARK: - Private functions
    
    /// Add new Cell
    private mutating func addNewCell() {
        guard
            let cell = cells.filter({$0.number == 0}).randomElement(),
            let index = cells.firstIndex(of: cell),
            let newNumber = GameEngine.startNumbers.randomElement()
        else { return }
        cells[index].number = newNumber
    }
    
    private func checkIsGameOver() -> Bool {
        let zeroNums = cells.filter({$0.number == 0}).count
        for id in (0..<cells.count) {
            let curPos = id
            let nextUp = getNextPos(curPos: curPos, move: .up)
            let nextDown = getNextPos(curPos: curPos, move: .down)
            let nextLeft = getNextPos(curPos: curPos, move: .left)
            let nextRight = getNextPos(curPos: curPos, move: .right)

            if (cells[curPos].number == cells[nextUp].number && curPos != nextUp)
                || (cells[curPos].number == cells[nextDown].number && curPos != nextDown)
                || (cells[curPos].number == cells[nextLeft].number && curPos != nextLeft)
                || (cells[curPos].number == cells[nextRight].number && curPos != nextRight) {
                return false
            }
        }
        return zeroNums == 0
    }
    
    /// Animate Cell by index
    mutating func animateCell(index: Int) {
        self.cells[index].animate.toggle()
    }
    
    // MARK: Get Position by direction and selected row and column
    // Row and column range: 0..<rank
    private func getPosition(to move: Direction, row: Int, column: Int, offset: Int = 0) -> Int {
        let range = (0..<rank)
        switch move {
        case .up:
            let newRow = range.contains(column - offset) ? column - offset : 0
            return newRow * rank + row
        case .down:
            let newRow = range.contains(rank - column - 1 + offset) ? rank - column - 1 + offset : rank - 1
            return newRow * rank + row
        case .left:
            let newCol = range.contains(column - offset) ? column - offset : 0
            return row * rank + newCol
        case .right:
            let newCol = range.contains(rank - column - 1 + offset) ? rank - column - 1 + offset : rank - 1
            return row * rank + newCol
        }
    }
    
    /// Get next position by direction
    private func getNextPos(curPos: Int, move: Direction) -> Int {
        var nextPos = 0
        switch move {
        case .up:
            nextPos = curPos >= rank ? curPos - rank : curPos
        case .down:
            nextPos = curPos < (rank-1)*rank ? curPos + rank : curPos // TODO
        case .left:
            nextPos = curPos % rank > 0 ? curPos - 1 : curPos
        case .right:
            nextPos = curPos % rank < rank - 1 ? curPos + 1 : curPos // TODO
        }
        return nextPos
    }
    
    /// Sort Cells by Direction
    @discardableResult
    private mutating func sortCells(to move: Direction) -> Bool {
        var isSorted = false
        for row in (0..<rank){
            var zeroCount = 0
            for column in (0..<rank) {
                let curPos = getPosition(to: move, row: row, column: column)
                if cells[curPos].number == 0 {
                    zeroCount+=1
                } else {
                    let newPos = getPosition(to: move, row: row, column: column, offset: zeroCount)
                    if newPos >= 0 && newPos < rank*rank && newPos != curPos {
                        let tempCell = cells[newPos]
                        cells[newPos] = cells[curPos]
                        cells[curPos] = tempCell
                        isSorted = true
                    }
                }
            }
        }
        return isSorted
    }

    /// Sum Cells
    @discardableResult
    private mutating func sumCells(to move: Direction) -> Bool {
        var isSum = false
        for row in (0..<rank){
            for column in (0..<rank) {
                let curPos = getPosition(to: move, row: row, column: column)
                let nextPos = getPosition(to: move, row: row, column: column, offset: 1)
                
                if cells[nextPos].number == cells[curPos].number && cells[curPos].number > 0 && curPos != nextPos {
                    isSum = true
                    cells[nextPos].number *= 2
                    cells[curPos].number = 0
                    score += cells.reduce(0) { $0 + $1.number }
                    if score > bestScore {
                        bestScore = score
                        bestMoves = moves
                    }
                    animateCell(index: nextPos)
                }
            }
        }
        return isSum
    }
}
