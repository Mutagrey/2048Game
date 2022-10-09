//
//  NumbersGameApp.swift
//  2048Game
//
//  Created by Sergey Petrov on 10.09.2022.
//

import SwiftUI

@main
struct NumbersGameApp: App {
    
    @StateObject var vm = GameViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainGameView()
                .preferredColorScheme(.light)
                .environmentObject(vm)
        }
    }
}
