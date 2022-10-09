//
//  GameDataManager.swift
//  2048Game
//
//  Created by Sergey Petrov on 20.09.2022.
//

import SwiftUI
import Combine

class GameDataManager {
    
    @Published private(set) var game: GameEngine?
    private var cancelables = Set<AnyCancellable>()
    
    init() {
        loadCellsFromLocalURL()
    }
    
    /// Load single Note from local folder and append it to `notes`.
    private func loadCellsFromLocalURL() {
        LocalFileManager.getJSON(from: LocalFileManager.rootURL.appendingPathComponent("GameData.json"))
            .decode(type: GameEngine.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(_):
                    print("[⚠️] Local data is empty...Loading from URL....\(LocalFileManager.rootURL.path)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] game in
                guard let self = self else { return }
                self.game = game
            })
            .store(in: &cancelables)
    }
    
    /// Save Node to local folder
    func saveCells(game: GameEngine) {
        let jsonURL = LocalFileManager.rootURL.appendingPathComponent("GameData.json")
        LocalFileManager.saveJSON(to: jsonURL, data: game)
    }
}
