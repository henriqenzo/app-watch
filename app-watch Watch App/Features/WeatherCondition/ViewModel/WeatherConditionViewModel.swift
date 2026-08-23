//
//  WeatherConditionViewModel.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 20/08/26.
//

import Foundation
import SwiftUI
import WeatherKit
import CoreLocation

private enum Thresholds {
    static let extremeHeatApparent: Double = 39
    static let hotApparent: Double = 30
    static let coldApparent: Double = 7
    static let strongWindKmh: Double = 40
    static let highHumidity: Double = 0.85
}

@Observable
final class WeatherConditionViewModel: NSObject, CLLocationManagerDelegate {
    
    private(set) var temperature: Int?
    private(set) var condition: WeatherCondition = .good
    private(set) var errorMessage: String?
    private(set) var isLoading = false
    
    private let weatherManager: WeatherManager
    private let locationManager = CLLocationManager()
    
    init(weatherManager: WeatherManager = WeatherManager()) {
        self.weatherManager = weatherManager
        super.init()
        locationManager.delegate = self
    }
    
    func requestWeather() {
        isLoading = true
        errorMessage = nil
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        Task {
            await loadWeather(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "Não foi possível obter sua localização"
        isLoading = false
    }
    
    private func loadWeather(latitude: Double, longitude: Double) async {
        do {
            let weather = try await weatherManager.fetchCurrentWeather(latitude: latitude, longitude: longitude)
            temperature = Int(weather.temperature.converted(to: .celsius).value.rounded())
            condition = evaluate(weather)
        } catch {
            errorMessage = "Não foi possível carregar o clima"
        }
        isLoading = false
    }

    private func evaluate(_ weather: CurrentWeather) -> WeatherCondition {
        let evaluators: [(CurrentWeather) -> WeatherCondition?] = [
            evaluatePrecipitation,
            evaluateHeat,
            evaluateCold,
            evaluateWind,
            evaluateHumidity
        ]
        
        for evaluator in evaluators {
            if let condition = evaluator(weather) {
                return condition
            }
        }
        
        return .good
    }
    
    private func evaluatePrecipitation(_ weather: CurrentWeather) -> WeatherCondition? {
        switch weather.condition {
        case .thunderstorms, .strongStorms, .isolatedThunderstorms, .scatteredThunderstorms, .heavyRain, .hail:
            return .storm
        case .rain, .drizzle, .freezingRain, .sunShowers:
            return .rain
        default:
            return nil
        
        }
    }
    
    private func evaluateHeat(_ weather: CurrentWeather) -> WeatherCondition? {
        let apparent = weather.apparentTemperature.converted(to: .celsius).value
        if apparent >= Thresholds.extremeHeatApparent { return .extremeHeat }
        if apparent >= Thresholds.hotApparent { return .hot }
        return nil
    }
    
    private func evaluateCold(_ weather: CurrentWeather) -> WeatherCondition? {
        let apparent = weather.apparentTemperature.converted(to: .celsius).value
        return apparent <= Thresholds.coldApparent ? .cold : nil
    }
    
    private func evaluateWind(_ weather: CurrentWeather) -> WeatherCondition? {
        let kmh = weather.wind.speed.converted(to: .kilometersPerHour).value
        return kmh >= Thresholds.strongWindKmh ? .strongWind : nil
    }
    
    private func evaluateHumidity(_ weather: CurrentWeather) -> WeatherCondition? {
        weather.humidity >= Thresholds.highHumidity ? .highHumidity : nil
    }
}
