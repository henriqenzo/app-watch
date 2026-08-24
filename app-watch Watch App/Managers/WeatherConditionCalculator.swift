//
//  WeatherConditionCalculator.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 24/08/26.
//

import Foundation
import WeatherKit


private enum Thresholds {
    static let extremeHeatApparent: Double = 39
    static let hotApparent: Double = 30
    static let coldApparent: Double = 7
    static let strongWindKmh: Double = 40
    static let highHumidity: Double = 0.85
    static let highUV: Double = 8
    
    static let peakSunHours: ClosedRange<Int> = 11...15
    static let sunAggravatedApparentThreshold: Double = 27
}

struct WeatherConditionCalculator {
    
    func evaluate(_ weather: CurrentWeather) -> WeatherCondition {
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
        let hour = Calendar.current.component(.hour, from: Date())
        
        let isPeakHour = Thresholds.peakSunHours.contains(hour)
        let isHighUV = Double(weather.uvIndex.value) >= Thresholds.highUV
        let isSunAggravated = isPeakHour || isHighUV
        
        if apparent >= Thresholds.extremeHeatApparent {
            return .extremeHeat
        }
        if isSunAggravated && apparent >= Thresholds.sunAggravatedApparentThreshold {
            return .extremeHeat
        }
        if apparent >= Thresholds.hotApparent {
            return .hot
        }
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
