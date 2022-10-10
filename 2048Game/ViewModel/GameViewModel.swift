//
//  GameViewModel2.swift
//  2048Game
//
//  Created by Sergey Petrov on 20.09.2022.
//

import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    
    @Published private var game: GameEngine = GameEngine(rank: 4)
    
    var cells: [Cell] { game.cells }
    var moves: Int { game.moves }
    var score: Int { game.score }
    var bestScore: Int { game.bestScore }
    var bestMoves: Int { game.bestMoves }
    var isGameOver: Bool { game.isGameOver }
    var rank: Int { game.rank }
    var lastMove: GameEngine.Direction? { game.lastMove }
    
    private var cancelables = Set<AnyCancellable>()
    private let dataStore = GameDataManager()
    
    init() {
        loadGame()
    }
    
    // Load saved game
    private func loadGame(){
        dataStore.$game
            .sink{ [weak self] game in
                guard
                    let self = self,
                    let game = game
                else { return }
                self.game = game
            }
            .store(in: &cancelables)
    }
    
    // Save game to local folder
    func saveCells() {
        self.dataStore.saveCells(game: game)
    }
    
    // Move cells to direction
    func moveCell(to move: GameEngine.Direction) {
        game.moveCell(to: move)
    }
    
    // Reset Game
    func resetGame(rank: Int) {
        game.createNewGame(rank: rank)
    }
    
    // Reset best scote
    func resetBestScore() {
        game.resetBestScore()
    }
    
    // Animate Cell when sum
    func animateCell(_ cell: Cell) {
        guard let index = cells.firstIndex(of: cell) else { return }
        game.animateCell(index: index)
    }
}


