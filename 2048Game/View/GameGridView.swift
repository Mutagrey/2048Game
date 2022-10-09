//
//  GameGridView.swift
//  2048Game
//
//  Created by Sergey Petrov on 19.09.2022.
//

import SwiftUI

struct GameGridView: View {
    @EnvironmentObject var game: GameViewModel
    @State private var cellsSet = Set<String>()
    @State private var isMoving = false
    
    private struct GameConstants {
        static let animationDuration: CGFloat = 0.15
        static let totalAnimationDuration: CGFloat = 3
        static let distanceSence: CGFloat = 50
        static let cornerRadius: CGFloat = 5
        static let cellPadding: CGFloat = 4
    }
    
    var body: some View {
        ZStack{
            Color.theme.gridColor.transaction { $0.animation = nil }.cornerRadius(GameConstants.cornerRadius * 2)
            backgrounView
            gridView
        }
        .aspectRatio(1, contentMode: .fit)
        .padding(GameConstants.cellPadding)
        // Drag gesture to move Cells
        .gesture(
            DragGesture()
                .onChanged{ value in
                    withAnimation(.easeInOut(duration: GameConstants.animationDuration)) {
                        self.dragAction(in: value)
                    }
                }
                .onEnded{ _ in
                    self.isMoving = false
                }
        )
    }
    
    // MARK: - Views
    // MARK: Background View
    private var backgrounView: some View {
        GridView(items: game.cells, aspectRatio: 1) { _ in
            RoundedRectangle(cornerRadius: GameConstants.cornerRadius)
                .fill(Color.theme.cellBackColor)
                .shadow(color: .black.opacity(0.15), radius: 5, x: -5, y: 5)
                .padding(GameConstants.cellPadding)
        }
        .transaction { $0.animation = nil }
        .padding(GameConstants.cellPadding)
    }
    // MARK: Grid View
    private var gridView: some View {
        GridView(items: game.cells, aspectRatio: 1) { cell in
            if isUnDealt(cell) || cell.number == 0 {
                Color.clear
            } else {
                CellView(cell: cell)
                    .padding(GameConstants.cellPadding)
                    .transition(.asymmetric(insertion: .scale, removal: .scale).animation(.easeOut(duration: GameConstants.animationDuration)))
            }
        }
        .padding(GameConstants.cellPadding)
        .onChange(of: game.cells){ newValue in
            for cell in game.cells {
                withAnimation(animationDeal(cell)) {
                    addCellToSet(cell)
                }
                animateCell(cell)
            }
        }
    }
    
    // MARK: - Drag function
    private func dragAction(in value: DragGesture.Value) {
        let dx = value.translation.width
        let dy = value.translation.height
        if abs(dx) > abs(dy) {
            if dx < -GameConstants.distanceSence && !isMoving {
                isMoving = true
                game.moveCell(to: .left)
                return
            }
            if dx > GameConstants.distanceSence && !isMoving {
                isMoving = true
                game.moveCell(to: .right)
                return
            }
        } else {
            if dy < -GameConstants.distanceSence && !isMoving {
                isMoving = true
                game.moveCell(to: .up)
                return
            }
            if dy > GameConstants.distanceSence && !isMoving {
                isMoving = true
                game.moveCell(to: .down)
                return
            }
        }
    }
    
    // MARK: - Animation
    private func animateCell(_ cell: Cell) {
        withAnimation(.spring(response: GameConstants.animationDuration + 0.1, dampingFraction: GameConstants.animationDuration + 0.2, blendDuration: GameConstants.animationDuration + 0.2).repeatCount(1, autoreverses: false)) {
        if cell.animate {
            DispatchQueue.main.asyncAfter(deadline: .now() + GameConstants.animationDuration * 1 + 0.01) {
                
                    self.game.animateCell(cell)
                }
            }
        }
    }
    
    private func addCellToSet(_ cell: Cell) {
        cellsSet.insert(cell.id)
    }
    
    private func animationDeal(_ cell: Cell) -> Animation {
        var delay = 0.0
        if let index = game.cells.firstIndex(of: cell) {
            delay = Double(index) * (GameConstants.totalAnimationDuration / Double(game.cells.count))
        }
        return Animation.easeInOut(duration: GameConstants.animationDuration).delay(delay)
    }
    
    private func isUnDealt(_ cell: Cell) -> Bool {
        !cellsSet.contains(cell.id)
    }
    
    
}

struct GameGridView_Previews: PreviewProvider {
    static var previews: some View {
        MainGameView()
            .environmentObject(GameViewModel())
    }
}
