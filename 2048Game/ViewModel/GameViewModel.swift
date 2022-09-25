//
//  GameViewModel2.swift
//  2048Game
//
//  Created by Sergey Petrov on 20.09.2022.
//

import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    
    @Published var cells: [Cell] = []
    @Published var movesArray: [Int] = []
    @Published var scoreArray: [Int] = []
    
    @AppStorage("moves") var moves: Int = 0
    @AppStorage("score") var score: Int = 0
    @AppStorage("bestScore") var bestScore: Int = 0
    @AppStorage("bestMoves") var bestMoves: Int = 0
    @AppStorage("rank") var rank: Int = 4
    
    @Published var isGameOver: Bool = false
    
    private var cancelables = Set<AnyCancellable>()
    let managers: GameManagers
    
    init(managers: GameManagers) {
        self.managers = managers
        addSubscribers()
    }
    
    private func addSubscribers(){
        
        managers.cellsDataManager.$cells
            .dropFirst() // need to avoid empty cells array
            .sink{ [weak self] cells in
                guard let self = self else { return }
                    self.managers.gameEngine.cells = cells
            }
            .store(in: &cancelables)
        
        managers.gameEngine.$cells
            .dropFirst() // need to avoid empty cells array
            .sink { [weak self] cells in
                guard let self = self else { return }
                self.cells = cells
            }
            .store(in: &cancelables)
        
        managers.gameEngine.$isGameOver
            .sink{ [weak self] isGameOver in
                guard let self = self else { return }
                    self.isGameOver = isGameOver
            }
            .store(in: &cancelables)
        
        if self.cells.isEmpty {
            managers.gameEngine.resetGame()
        }
    }
    
    /// Move cells to direction
    func moveCell(to move: GameEngine.Direction) {
        managers.gameEngine.moveCell(to: move)
    }
    
    /// Reset Game
    func resetGame() {
        managers.gameEngine.resetGame()
    }
    
    /// Save Cells to local folder
    func saveCells() {
        self.managers.cellsDataManager.cells = cells
        self.managers.cellsDataManager.saveCells()
    }
}


