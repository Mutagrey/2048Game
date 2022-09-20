//
//  GameModel.swift
//  2048Game
//
//  Created by Sergey Petrov on 10.09.2022.
//

import SwiftUI

struct Cell: Identifiable, Hashable, Codable {
    var id: String = UUID().uuidString
    var number: Int = 0
    var stringNumber: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ""
        return formatter.string(from: NSNumber(value: number)) ?? "0"
    }
    var animate: Bool = false
}



