//
//  InfoCard.swift
//  SumNumbersGame
//
//  Created by Sergey Petrov on 08.10.2022.
//

import SwiftUI

struct InfoCard: View {
    
    let title: String
    let subTitle: String?
    var titleFont: Font = .title
    
    var body: some View {
        VStack(spacing: 12){
            Text(title)
                .font(titleFont)
                .fontWeight(.heavy)
                .foregroundColor(.white.opacity(0.9))
                .shadow(color: .black.opacity(0.15), radius: 10, x: 5, y: 5)
           
            if let subTitle = subTitle {
                Text(subTitle)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.indigo)
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 5, y: 5)
            }
        }
        .frame(width: 100, height: 100)
        .background{ Color.theme.cardGradiend }
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(radius: 10, x: 5, y: 5)
    }
}

struct InfoCard_Previews: PreviewProvider {
    static var previews: some View {
        InfoCard(title: "Sss", subTitle: nil)
    }
}
