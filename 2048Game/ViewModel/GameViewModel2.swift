//
//  GameViewModel2.swift
//  2048Game
//
//  Created by Sergey Petrov on 20.09.2022.
//

import SwiftUI
import Combine

class GameViewModel2: ObservableObject {
    
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
    
    let dependencies: Dependences
    
    init(dependencies: Dependences) {
        self.dependencies = dependencies
        addSubscribers()
    }
    
    func addSubscribers(){
        
        dependencies.cellsDataManager.$cells
            .sink{ [weak self] cells in
                guard let self = self else { return }
                if cells.count > 0 {
                    self.dependencies.gameEngine.cells = cells
                }
            }
            .store(in: &cancelables)
        
        dependencies.gameEngine.$cells
            .dropFirst()
            .sink { [weak self] cells in
                guard let self = self else { return }
                self.cells = cells
            }
            .store(in: &cancelables)
    }
    
    
    func moveCell(to move: GameEngine.Direction) {
        dependencies.gameEngine.moveCell(to: move)
    }
    
    func resetGame() {
        dependencies.gameEngine.resetGame()
    }
    
    /// Save Cells to local folder
    func saveCells() {
        dependencies.cellsDataManager.saveCells()
    }
}


