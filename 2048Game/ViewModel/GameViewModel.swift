//
//  GameViewModel.swift
//  2048Game
//
//  Created by Sergey Petrov on 10.09.2022.
//

import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    
    @Published var cells: [Cell] = []

    @AppStorage("moves") var moves: Int = 0
    @AppStorage("score") var score: Int = 0
    @AppStorage("bestScore") var bestScore: Int = 0
    @AppStorage("rank") var rank: Int = 4
    
    @Published var isGameOver: Bool = false
    
    private var cancelables = Set<AnyCancellable>()
    
    enum Direction {
        case up
        case down
        case left
        case right
    }
    
    init() {
        loadCellsFromLocalURL()
    }
    
    /// Load single Note from local folder and append it to `notes`.
    private func loadCellsFromLocalURL() {
        LocalFileManager.getJSON(from: LocalFileManager.rootURL.appendingPathComponent("Cells.json"))
            .decode(type: [Cell].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(_):
                    print("[⚠️] Local data is empty...Loading from URL....\(LocalFileManager.rootURL.path)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] cells in
                guard let self = self else { return }
                self.cells = cells //.append(cell)
                
            })
            .store(in: &cancelables)
    }
    
    /// Save Node to local folder
    func saveCells() {
        // Gets JSON URL rootURL/Cells.json
        let jsonURL = LocalFileManager.rootURL.appendingPathComponent("Cells.json")
        LocalFileManager.saveJSON(to: jsonURL, data: self.cells)
    }
    
    /// Reset Game
    func resetGame(){
        moves = 0
        score = 0
        cells.removeAll()
        isGameOver = false
        for _ in (0..<rank*rank){
            cells.append(.init())
        }
        cells[(0..<rank*rank).randomElement()!].number = 2
        cells[(0..<rank*rank).randomElement()!].number = [2, 2, 4].randomElement()!
//        cells = MockCells()
    }
    
    func MockCells()->[Cell]{
        var curCells: [Cell] = []
        for _ in (0..<rank*rank){
            curCells.append(.init(number: 0))
        }
        
        curCells[4].number = 2
        curCells[5].number = 2
        curCells[6].number = 2
        curCells[7].number = 2
        
        curCells[1].number = 2
        curCells[5].number = 2
        curCells[9].number = 2
        curCells[13].number = 2
        
        return curCells
    }
    
    /// Add new Cell
    func addNewCell() {
        guard
            let cellID = cells.filter({$0.number == 0}).randomElement()?.id,
            let index = cells.firstIndex(where: {$0.id == cellID})
        else { return }
        cells[index].number = [2, 4].randomElement()!
    }
    
    /// Animate Cell by index
    private func animateCell(index: Int) {
        DispatchQueue.main.async {
            self.cells[index].animate = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeIn(duration: 0.1)){
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
    
//    /// Get next position by direction
//    private func getNextPos(curPos: Int, move: Direction) -> Int {
//        var nextPos = 0
//        switch move {
//        case .up:
//            nextPos = curPos >= rank ? curPos - rank : curPos
//        case .down:
//            nextPos = curPos < (rank-1)*rank ? curPos + rank : curPos // TODO
//        case .left:
//            nextPos = curPos % rank > 0 ? curPos - 1 : curPos
//        case .right:
//            nextPos = curPos % rank < rank - 1 ? curPos + 1 : curPos // TODO
//        }
//        return nextPos
//    }
//
//    /// Get last position by direction
//    private func getLastPos(curPos: Int, move: Direction) -> Int {
//        var lastPos = curPos
//        switch move {
//        case .up:
//            lastPos = (rank - 1)*rank + curPos % rank
//        case .down:
//            lastPos = curPos % rank
//        case .left:
//            lastPos = Int(Double(curPos) / Double(rank)) * rank + rank - 1
//        case .right:
//            lastPos = Int(Double(curPos) / Double(rank)) * rank
//        }
//        return lastPos
//    }
//
    /// Sawp cells position
    private func swapCells(position1: Int, position2: Int) {
        let tempCell = cells[position1]
        cells[position1] = cells[position2]
        cells[position2] = tempCell
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
                        swapCells(position1: newPos, position2: curPos)
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
                    if score > bestScore { bestScore = score }
                    animateCell(index: nextPos)
                }
            }
        }
        
//        for id in (0..<cells.count) {
//            let curPos = id
//            let nextPos = getNextPos(curPos: curPos, move: move)
//            if cells[nextPos].number == cells[curPos].number && cells[curPos].number > 0 && curPos != nextPos {
//                isSum = true
//                animateCell(index: nextPos)
//                cells[nextPos].number *= 2
//                cells[curPos].number = 0
//                score += cells.reduce(0) { $0 + $1.number }
//                if score > bestScore { bestScore = score }
//
//            }
//        }
        return isSum
    }
    
    /// Move Cell to Direction
    func moveCell(to move: Direction) {
        withAnimation(.easeInOut(duration: 0.2)) {
            let isSorted = self.sortCells(to: move)
            let isSum = self.sumCells(to: move)
            
            self.sortCells(to: move)
            if isSorted || isSum {
                self.addNewCell()
                self.moves += 1
                self.isGameOver = self.checkIsGameOver()
            }
        }
    }
    
    func checkIsGameOver() -> Bool {
        let zeroNums = cells.filter({$0.number == 0}).count
        
        
        for row in (0..<rank){
            for column in (0..<rank) {
                let curPos = getPosition(to: .up, row: row, column: column)
                let nextUp = getPosition(to: .up, row: row, column: column, offset: 1)
                let nextDown = getPosition(to: .down, row: row, column: column, offset: 1)
                let nextLeft = getPosition(to: .left, row: row, column: column, offset: 1)
                let nextRight = getPosition(to: .right, row: row, column: column, offset: 1)
                
                if (cells[curPos].number == cells[nextUp].number && curPos != nextUp)
                    || (cells[curPos].number == cells[nextDown].number && curPos != nextDown)
                    || (cells[curPos].number == cells[nextLeft].number && curPos != nextLeft)
                    || (cells[curPos].number == cells[nextRight].number && curPos != nextRight) {
                    return false
                }
            }
        }
        
        
//        for id in (0..<cells.count) {
//            let curPos = id
//            let nextUp = getNextPos(curPos: curPos, move: .up)
//            let nextDown = getNextPos(curPos: curPos, move: .down)
//            let nextLeft = getNextPos(curPos: curPos, move: .left)
//            let nextRight = getNextPos(curPos: curPos, move: .right)
//
//            if (cells[curPos].number == cells[nextUp].number && curPos != nextUp)
//                || (cells[curPos].number == cells[nextDown].number && curPos != nextDown)
//                || (cells[curPos].number == cells[nextLeft].number && curPos != nextLeft)
//                || (cells[curPos].number == cells[nextRight].number && curPos != nextRight) {
//                return false
//            }
//        }
        return zeroNums == 0
    }
}

