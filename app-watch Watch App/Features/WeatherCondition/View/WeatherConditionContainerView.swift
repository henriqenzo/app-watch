//
//  WeatherConditionContainerView.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 23/08/26.
//

import Foundation
import SwiftUI
import WeatherKit
import CoreLocation

struct WeatherConditionContainerView: View {
    var viewModel: WeatherConditionViewModel

    var body: some View {
        Group {
            if let temperature = viewModel.temperature {
                WeatherConditionView(temperature: temperature, condition: viewModel.condition)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.system(size: 12))
                    .multilineTextAlignment(.center)
            } else {
                ProgressView()
                Text("Carregando condições de clima")
            }
        }
    }
}
