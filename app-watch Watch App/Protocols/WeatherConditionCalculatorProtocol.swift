//
//  WeatherConditionCalculatorProtocol.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 26/08/26.
//

import Foundation
import WeatherKit

protocol WeatherConditionCalculatorProtocol {
    func evaluate(_ weather: CurrentWeather) -> WeatherCondition
}
