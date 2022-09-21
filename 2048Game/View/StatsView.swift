//
//  StatsView.swift
//  2048Game
//
//  Created by Sergey Petrov on 19.09.2022.
//

import SwiftUI
import Charts

struct StatsView: View {
    @EnvironmentObject var vm: GameViewModel
    var body: some View {
        Chart{
            ForEach(0..<vm.movesArray.count, id: \.self) { id in
                BarMark(x: .value("Move", vm.movesArray[id]),
                        y: .value("Score", vm.scoreArray[id]))
                .foregroundStyle(Color.indigo.gradient)
            }
            RuleMark(y: .value("Y", vm.bestScore))
//            BarMark(x: .value("BestMove", vm.bestMoves),
//                    y: .value("BestScore", vm.bestScore))
            .foregroundStyle(Color.red.gradient)
        }
//        .chartYScale(domain: .automatic, type: .log)
        .frame(height: 100)
        
//        Chart {
//            if let series = vm.selectedSeries {
//                ForEach(vm.selectedSeries?.dataPoints ?? [], id: \.self) { point in
//                    LineMark(x: .value("X", point.x ?? 0),
//                             y: .value("Y", point.y))
//                    .opacity(0.5)
//                    .foregroundStyle(by: .value("Y", series.name))
//                    .symbol(by: .value("Y", series.name))
//                    .symbolSize(100)
//                    .interpolationMethod(.catmullRom)
//                }
////                RuleMark(x: .value("X", vm.selectedNearestPoint?.x ?? 0))
////                    .opacity(0.3)
////                    .foregroundStyle(Color.red.gradient)
////                RuleMark(y: .value("Y", vm.selectedNearestPoint?.y ?? 0))
////                    .opacity(0.3)
////                    .foregroundStyle(Color.red.gradient)
//                PointMark(x: .value("X", vm.selectedPoint?.x ?? 0),
//                          y: .value("Y", vm.selectedPoint?.y ?? 0))
//                .foregroundStyle(Color.red.gradient.opacity(0.5))
//                PointMark(x: .value("X", vm.selectedNearestPoint?.x ?? 0),
//                          y: .value("Y", vm.selectedNearestPoint?.y ?? 0))
//                .foregroundStyle(Color.yellow.gradient.opacity(0.5))
//                .symbolSize(100)
//            }
//
//        }
//        .frame(height: 250)
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .environmentObject(GameViewModel(managers: GameManagers()))
    }
}
