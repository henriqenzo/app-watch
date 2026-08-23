//
//  WeatherConditionView.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 20/08/26.
//

import SwiftUI

struct WeatherConditionView: View {
    let temperature: Int
    let condition: WeatherCondition
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(spacing: 20) {
                Text("\(temperature)°")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(condition.color)
                    .padding()
                
                Image(systemName: condition.icon)
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .foregroundStyle(condition.color)
                    .padding()
                    .background(
                        Circle()
                            .stroke(condition.color)
                            .frame(width: 100)
                    )
            }
            
            VStack {
                Text(condition.title)
                    .foregroundStyle(condition.color)
                    .bold()
                
                Text(condition.subtitle)
                    .font(.system(size: 12))
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    WeatherConditionView(temperature: 31, condition: .strongWind)
}
