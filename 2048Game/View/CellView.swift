//
//  CellView.swift
//  2048Game
//
//  Created by Sergey Petrov on 10.09.2022.
//

import SwiftUI

struct CellView: View {
    var cell: Cell
    @State private var animate: Bool = false
    private let cornerRadius: CGFloat = 5
    var body: some View {
        ZStack{
            // Main Color
            Color.cellColor(number: cell.number)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            
            // GlassMorphic Card
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(
                    .linearGradient(colors: [
                        .white.opacity(0.25),
                        .white.opacity(0.05),
                        .clear
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .blur(radius: 5)
            
            // Borders
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(
                    .linearGradient(colors: [
                        .black.opacity(0.4),
//                        .red.opacity(0.6),
                        .purple.opacity(0.4),
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                    ,lineWidth: 1)
                .shadow(radius: 10)
   
        }
        //Shadows
//        .shadow(color: .black.opacity(0.15), radius: 5, x: 5, y: 5)
        .overlay {
            // MARK: Content
            Text("\(cell.stringNumber)")
                .font(.system(size: 30, weight: .bold, design: .monospaced))
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .foregroundColor(cell.number > 4 ? Color.white : Color("TextColor"))
                .shadow(color: .black.opacity(0.2), radius: 5, x: 5, y: 5)
//                .animation(.easeInOut(duration: 0.5), value: cell.number == 0 )
                .transition(.scale)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scaleEffect(cell.number > 0 ? 1 : 0.001)
        .opacity(cell.number > 0 ? 1 : 0)
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(cell: .init(number: 0))
    }
}
