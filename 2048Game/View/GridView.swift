//
//  GridView.swift
//  2048Game
//
//  Created by Sergey Petrov on 09.10.2022.
//

import SwiftUI

struct GridView<Item: Identifiable, ItemView: View>: View {
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView
    
    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        ZStack{
            LazyVGrid(columns: getColumns(), spacing: 0) {
                ForEach(items) { item in
                    content(item).aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
            Spacer(minLength: 0)
        }
    }
    
    private func getColumns() -> [GridItem]{
        let columnCount: Int = Int(sqrt(Double(items.count)))
        let column = GridItem(.flexible(), spacing: 0)
        return Array(repeating: column, count: columnCount)
    }
}

struct GridView_Previews: PreviewProvider {
    static let game = GameEngine(rank: 4)
    static var previews: some View {
        GridView(items: game.cells, aspectRatio: 1) { cell in
            Text("\(cell.number)")
        }
    }
}
