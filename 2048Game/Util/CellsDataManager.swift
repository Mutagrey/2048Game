//
//  CellsDataManager.swift
//  2048Game
//
//  Created by Sergey Petrov on 20.09.2022.
//

import SwiftUI
import Combine

class CellsDataManager {
    
    @Published var cells: [Cell] = []
    private var cancelables = Set<AnyCancellable>()
    
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
}
