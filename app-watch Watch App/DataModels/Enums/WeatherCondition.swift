//
//  WeatherCondition.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 20/08/26.
//

import Foundation
import SwiftUI
import WeatherKit

enum WeatherCondition: Codable{
    case good
    case hot
    case extremeHeat
    case rain
    case storm
    case strongWind
    case poorAirQuality
    case highHumidity
    case cold
    
    var title: String {
        switch self {
        case .good:
            "Bom pra correr"
        case .hot:
            "Corra com cuidado"
        case .extremeHeat:
            "Muito quente"
        case .rain:
            "Chuva provável"
        case .storm:
            "Evite correr"
        case .strongWind:
            "Corra com cuidado"
        case .poorAirQuality:
            "Qualidade do ar ruim"
        case .highHumidity:
            "Alta humidade"
        case .cold:
            "Muito frio"
        }
    }
    
    var subtitle: String {
        switch self {
        case .good:
            "Temperatura agradável"
        case .hot:
            "Reduza o ritmo e hidrate-se"
        case .extremeHeat:
            "O ideal é não correr nessas condições"
        case .rain:
            "Pode chover durante a corrida"
        case .storm:
            "Chuva forte e risco de trovoadas"
        case .strongWind:
            "Ventos fortes podem dificultar a corrida"
        case .poorAirQuality:
            "A qualidade do ar pode prejudicar a respiração"
        case .highHumidity:
            "O ar úmido pode aumentar o desconforto"
        case .cold:
            "Temperatura baixa! Proteja-se do frio"
        }
    }
    
    var icon: String {
        switch self {
        case .good:
            "figure.run"
        case .hot:
            "thermometer.sun"
        case .extremeHeat:
            "thermometer.high"
        case .rain:
            "cloud.rain"
        case .storm:
            "cloud.bolt.rain"
        case .strongWind:
            "wind"
        case .poorAirQuality:
            "aqi.high"
        case .highHumidity:
            "humidity"
        case .cold:
            "snowflake"
        }
    }
    
    var color: Color {
        switch self {
        case .good:
            Color("brandPrimaryColor")
        case .hot:
            Color("attention")
        case .extremeHeat:
            Color("warning")
        case .rain:
            Color("attention")
        case .storm:
            Color("warning")
        case .strongWind:
            Color("attention")
        case .poorAirQuality:
            Color("badAir")
        case .highHumidity:
            Color("information")
        case .cold:
            Color("cold")
        }
    }
    
}
