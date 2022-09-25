//
//  MetaGridView.swift
//  2048Game
//
//  Created by Sergey Petrov on 24.09.2022.
//

import SwiftUI

struct MetaGridView: View {
    @EnvironmentObject var vm: GameViewModel
    @GestureState var location: CGPoint = .zero
    @State private var isMoving = false
    private let distanceSence: CGFloat = 50
    var body: some View {
        
        ZStack{
            GeometryReader{ proxy in
//                backgroundGrid(cellSize: proxy.size.width)
                cellsGrid(cellSize: proxy.size)
                    .background{ Color.theme.gridColor }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
//            .padding(10)
            
            
        }
        
//        .clipShape(RoundedRectangle(cornerRadius: 10))
        .gesture(
        DragGesture(minimumDistance: 0)
            .updating($location, body: { value, out, _ in
                out = value.location
            })
            .onChanged{ value in
                let dx = value.translation.width
                let dy = value.translation.height
                withAnimation(.easeInOut(duration: 0.15)) {
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
        .coordinateSpace(name: "SPACE")
        .preferredColorScheme(.dark)
        .animation(.easeInOut, value: location == .zero)
    }
    
    func itemScale(rect: CGRect, size: CGSize)->CGFloat{
        let a = location.x - rect.midX
        let b = location.y - rect.midY
        let root = sqrt((a*a) + (b*b))
        let diagonalValue = sqrt((size.width*size.width) + (size.height*size.height))
        let scale = root / (diagonalValue / 0.02)
//        let scale = (root - 50) / 150
        
        let modifiedScale = location == .zero ? 1 : (1 - scale)
        
        return modifiedScale > 0 ? modifiedScale : 0.001
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
    private func cellsGrid(cellSize: CGSize) -> some View{
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: vm.rank)) {
            ForEach(vm.cells, id: \.id) { cell in
                GeometryReader{ innerProxy in
                    let rect = innerProxy.frame(in: .named("SPACE"))
                    let scale = itemScale(rect: rect, size: cellSize)
                    let transformedRect = rect.applying(.init(scaleX: scale, y: scale))
                    let transformedLocation = location.applying(.init(scaleX: scale, y: scale))
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.theme.cellBackColor)
                            .shadow(color: .black.opacity(0.15), radius: 5, x: -5, y: 5)

                        CellView(cell: cell)
    //                        .scaleEffect(scale)
    //                        .scaleEffect(cell.animate ? 1.2 : 1)
    //                        .transition(.scale)
//                            .opacity(cell.number > 0 ? 1 : 0)
//                            .offset(x: (transformedRect.midX - rect.midX), y: (transformedRect.midY - rect.midY))
//                            .offset(x: location.x - transformedLocation.x, y: location.y - transformedLocation.y)
//                            .scaleEffect(scale)
                    }
                    .offset(x: (transformedRect.midX - rect.midX), y: (transformedRect.midY - rect.midY))
                    .offset(x: location.x - transformedLocation.x, y: location.y - transformedLocation.y)
                    .scaleEffect(scale)
                }
                .frame(height: cellSize.width / CGFloat(vm.rank) - 10)
            }
        }
        .padding(10)
//        .background{ Color.theme.gridColor }
    }
}

struct MetaGridView_Previews: PreviewProvider {
    static var previews: some View {
        MetaGridView()
            .environmentObject(GameViewModel(managers: GameManagers()))
    }
}
