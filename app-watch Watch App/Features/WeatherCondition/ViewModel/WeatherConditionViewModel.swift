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
import WidgetKit

@Observable
final class WeatherConditionViewModel: NSObject, CLLocationManagerDelegate {
    
    private(set) var temperature: Int?
    private(set) var condition: WeatherCondition = .good
    private(set) var errorMessage: String?
    private(set) var isLoading = false
    
    private let weatherManager: WeatherManager
    private let calculator = WeatherConditionCalculator()
    private let locationManager = CLLocationManager()
    
    init(weatherManager: WeatherManager = WeatherManager()) {
        self.weatherManager = weatherManager
        super.init()
        locationManager.delegate = self
    }
    
    func requestWeather() {
        if let cached = WeatherConditionShared.load() {
            temperature = cached.temperature
            condition = cached.condition
        }
        
        guard WeatherConditionShared.load()?.isStale ?? true else {
            isLoading = false
            return
        }
        
        isLoading = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func loadWeather(latitude: Double, longitude: Double) async {
        do {
            let weather = try await weatherManager.fetchCurrentWeather(latitude: latitude, longitude: longitude)
            let temp = Int(weather.temperature.converted(to: .celsius).value.rounded())
            let cond = calculator.evaluate(weather)
            
            temperature = temp
            condition = cond
            WeatherConditionShared.save(WeatherConditionSnapshot(condition: cond, temperature: temp, timestamp: Date()))
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            errorMessage = "Não foi possível carregar o clima"
        }
        isLoading = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        WeatherConditionShared.saveLocation(
            LastLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        )
        
        Task {
            await loadWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "Não foi possível obter sua localização"
        isLoading = false
    }
}
