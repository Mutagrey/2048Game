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
    var animate: Bool = false
}



