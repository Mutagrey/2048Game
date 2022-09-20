//
//  Color.swift
//  2048Game
//
//  Created by Sergey Petrov on 18.09.2022.
//

import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let backgroundGradient = LinearGradient(colors: [
        .brown.opacity(0.3),
        .brown.opacity(0.2),
        .brown.opacity(0.5),
    ], startPoint: .top, endPoint: .bottom)
    let gridColor = Color("GridColor")
    let cellBackColor = Color("CellBackColor")
    
    func cellColor(number: Int)->Color{
        let color = Color("CellColor\(number)")
        return color == .white ? Color("CellColor2") : Color("CellColor\(number)")
    }
}
