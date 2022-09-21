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

    var body: some View {
        VStack(spacing: 20){
            topMenu
            midMenu
            GameGridView()
            botMenu
//            StatsView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background{
            Color.theme.backgroundGradient
                .ignoresSafeArea()
        }
        .overlay { if vm.isGameOver { gameOver } }
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
                    .fontWeight(.heavy)
                    .foregroundColor(.white.opacity(0.9))
            }
            .frame(width: 100, height: 100)
            .blendMode(.overlay)
            .background{
                LinearGradient(colors: [.purple.opacity(0.4), .indigo.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
            }
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            .shadow(radius: 5)
            Spacer()
            // score
            VStack{
                Text("Score")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer(minLength: 0)
                Text("\(vm.managers.gameEngine.score.formatUsingAbbrevation())")
                    .font(.title)
                    .fontWeight(.heavy)
                Spacer(minLength: 0)
            }
            .foregroundColor(.white.opacity(0.8))
            .padding(5)
            .blendMode(.overlay)
            .minimumScaleFactor(0.2)
            .lineLimit(1)
            .frame(width: 100, height: 100)
            .background{
                LinearGradient(colors: [.purple.opacity(0.4), .indigo.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
            }
            
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(radius: 5)
//            .background{
//
//                RoundedRectangle(cornerRadius: 10)
//                    .fill(Color("CellBackColor"))
//                    .shadow(radius: 5)
//            }
            // best
            VStack{
                Text("Best")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer(minLength: 0)
                Text("\(vm.bestScore.formatUsingAbbrevation())")
                    .font(.title)
                    .fontWeight(.heavy)
                Spacer(minLength: 0)
            }
            .foregroundColor(.white.opacity(0.8))
            .padding(5)
            .blendMode(.overlay)
            .minimumScaleFactor(0.2)
            .lineLimit(1)
            .frame(width: 100, height: 100)
            .background{
                LinearGradient(colors: [.purple.opacity(0.4), .indigo.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
            }
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(radius: 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var midMenu: some View {
        VStack(spacing: 20){
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
            Text("Join the numbers and get to the 2048 tile!")
                .foregroundColor(Color("TextColor"))
                .font(.headline)
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
                .opacity(vm.bestScore == vm.score && vm.score > 0  ? 1 : 0)

            
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
                    .foregroundColor(Color.red.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .font(.title.bold())
                    .padding()
                Text("Score")
                    .font(.title.bold())
                    .foregroundColor(Color.white.opacity(0.7))
                Text("\(vm.score)")
                    .font(.title.bold())
                    .foregroundColor(.purple)
                    .padding(.vertical)
                    .padding(.bottom)
            }
            .background{
                Color.theme.backgroundGradient
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .transition(.scale)
        .animation(.spring(), value: vm.isGameOver)
        .onTapGesture {
            vm.resetGame()
        }
    }
}

// MARK: - Preview
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(GameViewModel(managers: GameManagers()))
    }
}
