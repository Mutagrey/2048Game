//
//  MainGameView.swift
//  2048Game
//
//  Created by Sergey Petrov on 10.09.2022.
//

import SwiftUI

struct MainGameView: View {
    @EnvironmentObject var vm: GameViewModel
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("rank") private var rank: Int = 4
    
    var body: some View {
        VStack(spacing: 20){
            topMenu
            midMenu
            GameGridView()
            Spacer(minLength: 0)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .blur(radius: vm.isGameOver ? 10 : 0)
        .animation(.easeInOut, value: vm.isGameOver)
        .overlay(alignment: .bottom){
            botMenu
        }
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
    
    private var topMenu: some View {
        HStack{
            InfoCard(title: "2048", subTitle: nil)
            Spacer()
            InfoCard(title: "Score", subTitle: vm.score.formatUsingAbbrevation(), titleFont: .title2)
            InfoCard(title: "Best", subTitle: vm.bestScore.formatUsingAbbrevation(), titleFont: .title2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var midMenu: some View {
        VStack(spacing: 20){
            HStack{
                Button {
                    resetGame()
                } label: {
                    Text("New Game!")
                        .foregroundColor(Color.theme.textColor)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(5)
                }
                .buttonStyle(.borderedProminent)
                .accentColor(Color.theme.accentColor)
                .shadow(radius: 10, x: 5, y: 5)
                Button {
                    withAnimation(.spring()){
                        vm.resetBestScore()
                    }
                } label: {
                    Image(systemName: "gobackward")
                        .foregroundColor(Color.theme.textColor)
                        .padding(5)
                }
                .buttonStyle(.borderedProminent)
                .accentColor(Color.theme.accentColor)
                .shadow(radius: 10, x: 5, y: 5)
            }
            Text("Join the numbers and get to the 2048 tile!")
                .foregroundColor(Color.theme.textColor)
                .font(.headline)
        }
    }
    
    private var botMenu: some View {
        VStack(spacing: 10.0){
            Group {
                Text("Hight Score!")
                    .font(.title2.bold())
                    .foregroundColor(.indigo)
                Text("\(vm.bestScore)")
                    .font(.title.bold())
                    .foregroundColor(.indigo)
                    .minimumScaleFactor(0.1)
            }
            .padding(.horizontal)
            .opacity(vm.bestScore == vm.score && vm.score > 0  ? 1 : 0)
            
            Stepper("Rank \(vm.rank)", value: $rank, in: 2...6, step: 1) { _ in resetGame() }
                .foregroundColor( Color.theme.textColor)
            
        }
        .padding()
    }
    
    private var gameOver: some View{
        ZStack{
            Color.black.opacity(0.6).ignoresSafeArea()
            VStack(spacing: 20){
                Text("Game Over")
                    .foregroundColor(Color.red.opacity(0.7))
                    .font(.title.bold())
                Text("Score")
                    .font(.title2.bold())
                    .foregroundColor(Color.white.opacity(0.7))
                Text("\(vm.score)")
                    .font(.title.bold())
                    .foregroundColor(.indigo)
            }
            .padding()
            .background(.ultraThinMaterial.opacity(0.7), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(radius: 10)
        }
        .transition(.opacity)
        .onTapGesture { resetGame() }
    }
    
    private func resetGame() {
        withAnimation(.easeOut(duration: 0.3)) {
            vm.resetGame(rank: rank)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainGameView()
            .environmentObject(GameViewModel())
    }
}
