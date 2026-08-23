//
//  WeatherManager.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 21/08/26.
//


import Foundation
import WeatherKit
import CoreLocation

struct WeatherManager {
    private let service = WeatherService()
    
    func fetchCurrentWeather(latitude: Double, longitude: Double) async throws -> CurrentWeather {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        let weather = try await service.weather(for: location)
        
        return weather.currentWeather
    }
}
