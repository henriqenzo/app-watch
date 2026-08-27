//
//  WeatherConditionManagerProtocol.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 26/08/26.
//

import Foundation
import WeatherKit

protocol WeatherManagerProtocol {
    func fetchCurrentWeather(latitude: Double,longitude: Double) async throws -> CurrentWeather
}
