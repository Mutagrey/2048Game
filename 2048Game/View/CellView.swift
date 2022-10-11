//
//  CellView.swift
//  2048Game
//
//  Created by Sergey Petrov on 10.09.2022.
//

import SwiftUI

struct CellView: View, Animatable {
    var cell: Cell
    var lastMove: GameEngine.Direction?
    private var rotation: Double
    
    init(cell: Cell, lastMove: GameEngine.Direction?) {
        self.cell = cell
        self.lastMove = lastMove
        var maxRotation: Double = 0
        switch lastMove {
        case .up, .left: maxRotation = -CellViewConstants.maxDegrees
        case .down, .right: maxRotation = CellViewConstants.maxDegrees
        case .none: maxRotation = 0
        }
        self.rotation = cell.animate ? maxRotation : 0
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    private struct CellViewConstants {
        static let maxDegrees: Double = 25
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
    }
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: CellViewConstants.cornerRadius, style: .continuous)
        ZStack{
            // GlassMorphic Card
            shape.fill(CellViewConstants.glassMorphicStyle).blur(radius: 5)
            // Borders
            shape.stroke(CellViewConstants.strokeShapeStyle, lineWidth: CellViewConstants.lineWidth).shadow(radius: CellViewConstants.shadowRadius)
            // MARK: Content
            Text("\(cell.number.stringNumber)")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .foregroundColor(cell.number > 4 ? Color.white : Color.theme.textColor)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 5, y: 5)
                .opacity(abs(rotation) > 90 ? 0 : 1)
                .transition(.opacity)
                .id("Number\(cell.number)")
        }
        .background(Color.cellColor(number: cell.number), in: shape)
        .rotation3DEffect(Angle(degrees: rotation),
                          axis: ((lastMove == .up || lastMove == .down) ? 1 : 0, (lastMove == .left || lastMove == .right) ? 1 : 0, 0))
    }
    
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(cell: .init(number: 4), lastMove: .left)
            .environmentObject(GameViewModel())
    }
}
