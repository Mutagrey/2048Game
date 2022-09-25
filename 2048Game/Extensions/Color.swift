//
//  Color.swift
//  2048Game
//
//  Created by Sergey Petrov on 18.09.2022.
//

import SwiftUI

extension Color {
    static let theme = ColorTheme()
    static func cellColor(number: Int)->Color{
        return number > 0 && number % 2 == 0 ? Color("CellColor\(number)") : Color.clear
    }
}

struct ColorTheme {
    let backgroundGradient = LinearGradient(colors: [
        .brown.opacity(0.3),
        .brown.opacity(0.2),
        .brown.opacity(0.5),
    ], startPoint: .top, endPoint: .bottom)
    let cardGradiend = LinearGradient(colors: [Color("CellColor32"), Color(uiColor: .systemYellow).opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing)
    let gridColor = Color("GridColor")
    let cellBackColor = Color("CellBackColor")
    let textColor = Color("TextColor")
    let accentColor = Color("GameAccentColor")
}
