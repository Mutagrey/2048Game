//
//  Double.swift
//  2048Game
//
//  Created by Sergey Petrov on 18.09.2022.
//

import SwiftUI

extension Int {
    private var scoreFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        formatter.locale = .current
        
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    func asScoreNumber() -> String {
        let number = NSNumber(value: self)
        return scoreFormatter.string(from: number) ?? "-"
    }
}

