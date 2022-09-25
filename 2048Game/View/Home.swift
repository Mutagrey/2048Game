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
    
    @ViewBuilder
    private func InfoCard(title: String, subTitle: String?, titleFont: Font = .title)-> some View{
        VStack(spacing: 12){
            Text(title)
                .font(titleFont)
                .fontWeight(.heavy)
                .foregroundColor(.white.opacity(0.9))
                .shadow(color: .black.opacity(0.15), radius: 10, x: 5, y: 5)
           
            if let subTitle = subTitle {
                Text(subTitle)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.indigo)
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 5, y: 5)
            }
        }
        .frame(width: 100, height: 100)
        .background{ Color.theme.cardGradiend }
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(radius: 10, x: 5, y: 5)
    }
    
    var topMenu: some View {
        HStack{
            InfoCard(title: "2048", subTitle: nil)
            Spacer()
            InfoCard(title: "Score", subTitle: vm.managers.gameEngine.score.formatUsingAbbrevation(), titleFont: .title2)
            InfoCard(title: "Best", subTitle: vm.bestScore.formatUsingAbbrevation(), titleFont: .title2)
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
                        vm.bestScore = 0
                        vm.managers.gameEngine.bestScore = 0
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
    
    var botMenu: some View {
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
//                .padding(.bottom)
                .opacity(vm.bestScore == vm.score && vm.score > 0  ? 1 : 0)

            Stepper("Rank: \(vm.rank)") {
                if vm.rank < 6 {
                    vm.rank += 1
                    vm.resetGame()
                }
            } onDecrement: {
                if vm.rank > 2 {
                    vm.rank -= 1
                    vm.resetGame()
                }
            }
            .foregroundColor( Color.theme.textColor)

        }
        .padding()
    }
    
    var gameOver: some View{
        ZStack{
            
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
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
        .onTapGesture {
            withAnimation(.easeInOut) {
                vm.resetGame()
            }
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
