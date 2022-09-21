//
//  GameGridView.swift
//  2048Game
//
//  Created by Sergey Petrov on 19.09.2022.
//

import SwiftUI

struct GameGridView: View {
    @EnvironmentObject var vm: GameViewModel
    @State private var isMoving = false
    private let distanceSence: CGFloat = 50
    var body: some View {
        ZStack{
            GeometryReader{ geo in
                backgroundGrid(cellSize: geo.size.width)
                cellsGrid(cellSize: geo.size.width)
            }
        }
        // Drag gesture to move Cells
        .gesture(
            DragGesture()
                .onChanged{ value in
                    let dx = value.translation.width
                    let dy = value.translation.height
                    withAnimation(.easeInOut(duration: 0.12)) {
                        if abs(dx) > abs(dy) {
                            if dx < -distanceSence && !isMoving {
                                isMoving = true
                                vm.moveCell(to: .left)
                                return
                            }
                            if dx > distanceSence && !isMoving {
                                isMoving = true
                                vm.moveCell(to: .right)
                                return
                            }
                        } else {
                            if dy < -distanceSence && !isMoving {
                                isMoving = true
                                vm.moveCell(to: .up)
                                return
                            }
                            if dy > distanceSence && !isMoving {
                                isMoving = true
                                vm.moveCell(to: .down)
                                return
                            }
                        }
                    }
                }
                .onEnded{ _ in
                    self.isMoving = false
                }
        )
    }
    
    // MARK: Background Grid
    private func backgroundGrid(cellSize: CGFloat) -> some View{
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10, alignment: .center), count: vm.rank))
        {
            ForEach(1...vm.rank*vm.rank, id: \.self) { item in
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.theme.cellBackColor)
                    .shadow(color: .black.opacity(0.15), radius: 5, x: -5, y: 5)
                    .frame(height: cellSize / CGFloat(vm.rank) - 10)
            }
        }
        .padding(10)
        .background{ Color.theme.gridColor }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // MARK: Cells Grid
    private func cellsGrid(cellSize: CGFloat) -> some View{
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10, alignment: .center), count: vm.rank)) {
            ForEach(vm.cells, id: \.id) { cell in
                CellView(cell: cell)
                    .frame(height: cellSize / CGFloat(vm.rank) - 10)
                    .transition(.scale)
                    .opacity(cell.number > 0 ? 1 : 0)
                    .scaleEffect(cell.animate ? 1.2 : 1)
            }
        }
        .padding(10)
    }
}

struct GameGridView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(GameViewModel(managers: GameManagers()))
    }
}
