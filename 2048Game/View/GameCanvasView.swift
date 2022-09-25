//
//  CellsGrid.swift
//  2048Game
//
//  Created by Sergey Petrov on 11.09.2022.
//

import SwiftUI

struct GameCanvasView: View {
    @EnvironmentObject var vm: GameViewModel

    var body: some View {

        Canvas { context, size in
            let gridSize: CGSize = .init(width: size.width, height: size.width)
            // Draw background
            context.fill(
                Path(roundedRect: CGRect(origin: .init(x: 0, y: 0), size: gridSize), cornerRadius: 10),
                with: .color(Color("GridColor")))

            // Draw cells
            let spacing: CGFloat = 10
            let cellSize: CGFloat = (size.width - spacing) / CGFloat(vm.rank) - spacing
            for index in 0..<vm.cells.count {
                let cell = vm.cells[index]
                let rw = vm.managers.gameEngine.getRow(index: index)
                let cl = vm.managers.gameEngine.getColumn(index: index)
                let curX: CGFloat = CGFloat(cl) * (cellSize + spacing) + spacing
                let curY: CGFloat = CGFloat(rw) * (cellSize + spacing) + spacing
                let cellRect = CGRect(origin: .init(x: curX, y: curY), size: .init(width: cellSize, height: cellSize))
                context.fill(
                    Path(roundedRect: cellRect, cornerRadius: 5),
                    with: .color(Color.theme.cellBackColor))
//                if cell.number > 0 {
//                    context.fill(
//                        Path(roundedRect: cellRect, cornerRadius: 5),
//                        with: .color(Color("CellColor")))
//                    context.draw(
//                        Text("\(cell.number)")
//                            .font(.system(size: 40, weight: .heavy, design: .rounded))
//                            .foregroundColor(Color("TextColor"))
//                        , at: .init(x: curX + cellSize / 2, y: curY + cellSize / 2), anchor: .center)
//                }

            }

            for index in 0..<vm.cells.count {
                let cell = vm.cells[index]
                let rw = vm.managers.gameEngine.getRow(index: index)
                let cl = vm.managers.gameEngine.getColumn(index: index)
                let symbol = context.resolveSymbol(id: cell.id)!
                let curX: CGFloat = CGFloat(cl) * (cellSize + spacing) + spacing
                let curY: CGFloat = CGFloat(rw) * (cellSize + spacing) + spacing
                context.draw(symbol, at: CGPoint(x: curX, y: curY), anchor: .topLeading)
            }

        } symbols: {
            ForEach(vm.cells, id: \.id) { cell in
                CellView(cell: cell)
                    .frame(width: 80, height: 80)
//                    .frame(height: 100 / CGFloat(vm.rank) - 10)
                    .opacity(cell.number > 0 ? 1 : 0)
                    .transition(.scale)
//                    .animation(.easeInOut)
                    .tag(cell.id)
            }
        }
//        .padding()
        .gesture(
            DragGesture()
            .onChanged{ value in
                getMove(value)
            }
        )
    }


    private func getMove(_ value: DragGesture.Value) {
        let point = value.location
    }
    func cellPath(in rect: CGRect, _ spacing: CGFloat = 5) -> Path {
//        let size = min(rect.width, rect.height)
        let path = Path() { path in
            path.move(to: .init(x: spacing, y: spacing))
            path.addLine(to: .init(x: rect.width - spacing, y: spacing))
            path.addLine(to: .init(x: rect.width - spacing, y: rect.height - spacing))
            path.addLine(to: .init(x: spacing, y: rect.height - spacing))
            path.addLine(to: .init(x: spacing, y: spacing))
        }
        return path
    }
}

struct CellsGrid_Previews: PreviewProvider {
    static var previews: some View {
        GameCanvasView()
            .environmentObject(GameViewModel(managers: GameManagers()))
    }
}

