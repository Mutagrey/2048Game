//
//  GameEngine.swift
//  2048Game
//
//  Created by Sergey Petrov on 18.09.2022.
//

import SwiftUI

class GameEngine: ObservableObject {

    @Published var cells: [Cell] = []
    @Published var movesArray: [Int] = []
    @Published var scoreArray: [Int] = []
    
    @AppStorage("moves") var moves: Int = 0
    @AppStorage("score") var score: Int = 0
    @AppStorage("bestScore") var bestScore: Int = 0
    @AppStorage("bestMoves") var bestMoves: Int = 0
    @AppStorage("rank") var rank: Int = 4
    
    @Published var isGameOver: Bool = false
    
    enum Direction {
        case up
        case down
        case left
        case right
    }

    /// Reset Game
    func resetGame(){
        moves = 0
        movesArray.removeAll()
        score = 0
        scoreArray.removeAll()
        cells.removeAll()
        isGameOver = false
        for _ in (0..<rank*rank){
            cells.append(.init())
        }
        cells[(0..<rank*rank).randomElement()!].number = 2
        cells[(0..<rank*rank).randomElement()!].number = [2, 2, 4].randomElement()!
    }

    /// Add new Cell
    func addNewCell() {
        guard
            let cellID = cells.filter({$0.number == 0}).randomElement()?.id,
            let index = cells.firstIndex(where: {$0.id == cellID})
        else { return }
        cells[index].number = [2, 4].randomElement()!
    }

    /// Move Cell to Direction
    func moveCell(to move: Direction) {
        let isSorted = self.sortCells(to: move)
        let isSum = self.sumCells(to: move)
        if isSorted || isSum {
            self.sortCells(to: move)    // Sort again after sum cells
            self.addNewCell()           // add new cell if we have empty cells
            self.moves += 1
            self.movesArray.append(self.moves)
            self.isGameOver = self.checkIsGameOver()
        }
    }
    
    func checkIsGameOver() -> Bool {
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
    private func animateCell(index: Int) {
        DispatchQueue.main.async {
            self.cells[index].animate = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeIn(duration: 0.05)){
                    self.cells[index].animate = false
                }
            }
        }
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
    private func sortCells(to move: Direction) -> Bool {
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
    private func sumCells(to move: Direction) -> Bool {
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
        scoreArray.append(score)
        return isSum
    }

    /// Get Row by Cells Index
    func getRow(index: Int) -> Int {
        return Int(Double(index) / Double(rank))
    }
    
    /// Get Column by Cells Index
    func getColumn(index: Int) -> Int {
        return index % rank
    }
}
