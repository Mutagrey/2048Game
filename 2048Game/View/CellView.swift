//
//  CellView.swift
//  2048Game
//
//  Created by Sergey Petrov on 10.09.2022.
//

import SwiftUI

struct CellView: View, Animatable {

    var cell: Cell
    var rotation: Double
    
    init(cell: Cell) {
        self.cell = cell
        self.rotation = cell.animate ? 180 : 0
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }

    private struct CellViewConstants {
        static let cornerRadius: CGFloat = 5
        static let lineWidth: CGFloat = 1
        static let shadowRadius: CGFloat = 10
        static let strokeShapeStyle: LinearGradient = .linearGradient(colors: [
            .black.opacity(0.4),
            .purple.opacity(0.4),
        ], startPoint: .topLeading, endPoint: .bottomTrailing)
        static let glassMorphicStyle: LinearGradient = .linearGradient(colors: [
            .white.opacity(0.25),
            .white.opacity(0.05),
            .clear
        ], startPoint: .topLeading, endPoint: .bottomTrailing)
        
        static let animationDuration: CGFloat = 3
    }
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: CellViewConstants.cornerRadius, style: .continuous)
        ZStack{
            // GlassMorphic Card
            shape.fill(CellViewConstants.glassMorphicStyle)
                .blur(radius: 5)
            // Borders
            shape.stroke(CellViewConstants.strokeShapeStyle, lineWidth: CellViewConstants.lineWidth)
                .shadow(radius: CellViewConstants.shadowRadius)
            // MARK: Content
//            if animate {
                Text("\(cell.stringNumber)")
                    .font(.system(size: 30, weight: .bold, design: .monospaced))
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                    .foregroundColor(cell.number > 4 ? Color.white : Color.theme.textColor)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 5, y: 5)
                    .opacity(rotation > 90 ? 0 : 1)
//            }

        }
        .background(Color.cellColor(number: cell.number), in: shape)
        .rotation3DEffect(Angle(degrees: rotation), axis: (x: 0, y: 1, z: 0))
//        .animation(.easeIn(duration: 3), value: UUID())
    }
    
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(cell: .init(number: 4))
            .environmentObject(GameViewModel())
    }
}
