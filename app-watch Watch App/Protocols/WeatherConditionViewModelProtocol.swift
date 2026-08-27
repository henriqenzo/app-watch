//
//  WeatherConditionViewModelProtocol.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 26/08/26.
//

import Foundation

protocol WeatherConditionViewModelProtocol: AnyObject {
    var temperature: Int? { get }
    var condition: WeatherCondition { get }
    var errorMessage: String? { get }
    var isLoading: Bool { get }
    
    func requestWeather()
}
