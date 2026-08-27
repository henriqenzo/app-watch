//
//  WeatherManager.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 21/08/26.
//


import Foundation
import CoreLocation
import WeatherKit

// MARK: - WeatherManager
// Responsável por buscar os dados do clima
struct WeatherManager: WeatherManagerProtocol{
    // Serviço do WeatherKit responsável por consultar os dados meteorológicos.
    private let service = WeatherService()
    
    // MARK: - FetchCurrentWeather
    // Busca o clima atual usando latitude e longitude.
    func fetchCurrentWeather(latitude: Double, longitude: Double) async throws -> CurrentWeather {
        // Cria uma localização a partir das coordenadas recebidas.
        let location = CLLocation(latitude: latitude, longitude: longitude)
        // Consulta o WeatherKit para obter os dados do clima.
        let weather = try await service.weather(for: location)
        
        // Retorna somente os dados do clima atual.
        return weather.currentWeather
    }
}
