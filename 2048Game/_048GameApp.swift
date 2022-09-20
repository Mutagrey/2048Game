//
//  _048GameApp.swift
//  2048Game
//
//  Created by Sergey Petrov on 10.09.2022.
//

import SwiftUI

@main
struct _048GameApp: App {
//    @StateObject var vm = GameViewModel()
    @StateObject var vm: GameViewModel2
    
    init() {
        _vm = StateObject(wrappedValue: GameViewModel2(dependencies: Dependences()))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
        }
    }
}
