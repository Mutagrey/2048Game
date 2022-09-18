//
//  Home.swift
//  2048Game
//
//  Created by Sergey Petrov on 10.09.2022.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var vm: GameViewModel
    @Environment(\.scenePhase) var scenePhase
    @State private var isMoving = false
    
    @Namespace var animation
    var body: some View {
        VStack(spacing: 20){
            topMenu
            midMenu
            Text("Join the numbers and get to the 2048 tile!")
                .foregroundColor(Color("TextColor"))
                .font(.headline)
            gameField
            botMenu
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background{
            LinearGradient(colors: [
                .brown.opacity(0.3),
                .brown.opacity(0.2),
                .brown.opacity(0.5),
            ], startPoint: .top, endPoint: .bottom)
//            Color("MainBGColor")
//            Color.black.gradient
                .ignoresSafeArea()
        }
        .overlay { gameOver }
        .onChange(of: scenePhase) { newValue in
            if newValue == .background || newValue == .inactive {
                vm.saveCells()
            }
        }
    }
    
    var topMenu: some View {
        HStack{
            // icon label
            VStack{
                Text("2048")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextColor").opacity(0.8))
            }
            .frame(width: 100, height: 100)
            .background{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.yellow)
                    .shadow(radius: 5)
            }
            Spacer()
            // score
            VStack{
                Text("Score")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextColor"))
                Text("\(vm.score)")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.white.opacity(0.8))
                    .minimumScaleFactor(0.2)
                    .lineLimit(1)
                    .padding()
                Text("Moves: +\(vm.moves)")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.white.opacity(0.8))
                    .minimumScaleFactor(0.2)
                    .lineLimit(1)
//                    .padding()
            }
            .frame(width: 100, height: 100)
            .background(Material.ultraThinMaterial.opacity(0.5))
            
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(radius: 5)
//            .background{
//
//                RoundedRectangle(cornerRadius: 10)
//                    .fill(Color("CellBackColor"))
//                    .shadow(radius: 5)
//            }
            // best
            VStack(spacing: 10){
                Text("Best")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextColor"))
                Text("\(vm.bestScore)")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .minimumScaleFactor(0.2)
                    .lineLimit(1)
                    .foregroundColor(.white.opacity(0.8))
                    .padding()
            }
            .frame(width: 100, height: 100)
            .background{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("CellBackColor"))
                    .shadow(radius: 5)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var midMenu: some View {
        HStack{
            Button {
                withAnimation(.easeOut) {
                    vm.resetGame()
                }
            } label: {
                Text("New Game!")
                    .foregroundColor(Color("TextColor"))
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(5)
            }
            .buttonStyle(.borderedProminent)
            .accentColor(.yellow)
            Button {
                withAnimation(.spring()){
                    vm.bestScore = 0
                }
            } label: {
                Image(systemName: "gobackward")
                    .foregroundColor(Color("TextColor"))
                    .padding(5)
            }
            .buttonStyle(.borderedProminent)
            .accentColor(.yellow)
        }
    }
    
    var botMenu: some View {
        VStack(spacing: 0.0){
                Group {
                    Text("Record!")
                        .font(.title2.bold())
                    Text("\(vm.bestScore)")
                        .font(.title.bold())
                        .foregroundColor(.red)
                }
                .padding(.horizontal)
                .padding(.bottom)
                .opacity(vm.bestScore == vm.score  ? 1 : 0)

            
            Stepper("Rank: \(vm.rank)") {
                if vm.rank < 10 {
                    vm.rank += 1
                    vm.resetGame()
                }
            } onDecrement: {
                if vm.rank > 2 {
                    vm.rank -= 1
                    vm.resetGame()
                }
            }

        }
    }
    
    var gameOver: some View{
        ZStack{
            Color.black.opacity(0.75)
                .ignoresSafeArea()
            VStack{
                Text("Game Over")
                    .multilineTextAlignment(.center)
                    .font(.title.bold())
                    .padding()
                Text("Score")
                    .font(.title.bold())
                Text("\(vm.score)")
                    .font(.title.bold())
                    .foregroundColor(.yellow)
                    .padding(.bottom)
                    .padding(.bottom)
                    
            }
            .transition(.scale)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .background{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("GridColor"))
            }
        }
        .opacity(vm.isGameOver ? 1 : 0)
        .animation(.spring(), value: vm.isGameOver)
        .onTapGesture {
            vm.resetGame()
        }
    }
    
    // MARK: Background Grid
    func backgroundGrid(cellSize: CGFloat) -> some View{
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10, alignment: .center), count: vm.rank))
        {
            ForEach(1...vm.rank*vm.rank, id: \.self) { item in
                RoundedRectangle(cornerRadius: 5)
                    .fill(
                        Color("CellBackColor")//.gradient
                    )
                    .shadow(color: .black.opacity(0.15), radius: 5, x: -5, y: 5)
                    .frame(height: cellSize / CGFloat(vm.rank) - 10)
            }
        }
        .padding(10)
        .background{
            Color("GridColor")
//            ZStack{
//                RoundedRectangle(cornerRadius: 10, style: .continuous)
//                    .fill(
//                        LinearGradient(colors:
//                                        [
//                                            .black.opacity(0.2),
//                                            .black.opacity(0.1),
//                                            .purple.opacity(0.2)
//                                        ]
//                                       , startPoint: .topLeading, endPoint: .bottomTrailing)
//                    )
//                    .blur(radius: 5)
//                RoundedRectangle(cornerRadius: 10, style: .continuous)
//                    .stroke(
//                        LinearGradient(colors:
//                                        [
//                                            .black.opacity(0.6),
//                                            .purple.opacity(0.6)
//                                        ]
//                                       , startPoint: .topLeading, endPoint: .bottomTrailing)
//                        , lineWidth: 0.5)
//            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        
    }
    
    // MARK: Cells Grid
    func cellsGrid(cellSize: CGFloat) -> some View{
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10, alignment: .center), count: vm.rank)) {
            ForEach(vm.cells, id: \.id) { cell in
                CellView(cell: cell)
                    .frame(height: cellSize / CGFloat(vm.rank) - 10)
                    .transition(.scale)
                    .opacity(cell.number > 0 ? 1 : 0)
                    .scaleEffect(cell.animate ? 1.2 : 1)
//                    .matchedGeometryEffect(id: cell.id, in: animation)
//                    .animation(.easeInOut(duration: 0.5), value: (cell.number > 0))
            }
        }
        .padding(10)
    }
    // MARK: Main Grid
    var gameField: some View {
        ZStack{
            GeometryReader{ geo in
                backgroundGrid(cellSize: geo.size.width)
                cellsGrid(cellSize: geo.size.width)
            }
        }
        .clipped()
        .gesture(
            DragGesture()
                .onEnded{ value in
                    let dx = value.translation.width
                    let dy = value.translation.height
                    if abs(dx) > abs(dy) {
                        if dx < -30 {
                            vm.moveCell(to: .left)
                            return
                        }
                        if dx > 30 {
                            vm.moveCell(to: .right)
                            return
                        }
                    } else {
                        if dy < -30 {
                            vm.moveCell(to: .up)
                            return
                        }
                        if dy > 30 {
                            vm.moveCell(to: .down)
                            return
                        }
                    }
                }
            
        )
    }
}

// MARK: - Preview
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(GameViewModel())
    }
}
