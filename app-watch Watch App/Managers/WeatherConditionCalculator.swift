//
//  WeatherConditionCalculator.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 24/08/26.
//

import Foundation
import WeatherKit

// MARK: - Faixas de valores para definição do clima
private enum Thresholds {
    // Faixa para temperatura extrema
    static let extremeHeatApparent: Double = 39
    // Faixa para calor
    static let hotApparent: Double = 30
    // Faixa para frio
    static let coldApparent: Double = 7
    // Faixa para velocidade do vento
    static let strongWindKmh: Double = 40
    // Faixa para umidade alta
    static let highHumidity: Double = 0.85
    // Faixa para UV alto
    static let highUV: Double = 8
    
    // Faixa de horários para o pico de calor
    static let peakSunHours: ClosedRange<Int> = 11...15
    // Limiar de temperatura quente entre 11 e 15
    static let sunAggravatedApparentThreshold: Double = 27
}

// MARK: - WeatherConditionCalculator
// Realiza os calculos para definir o clima atual para corrida
struct WeatherConditionCalculator {
    
    // MARK: - Evaluate: Responsável por definir Avalia as condições climáticas em ordem de prioridade
    // Retorna a primeira condição identificada.
    func evaluate(_ weather: CurrentWeather) -> WeatherCondition {
        // Guarda as funcoes em uma lista
        let evaluators: [(CurrentWeather) -> WeatherCondition?] = [
            evaluatePrecipitation,
            evaluateHeat,
            evaluateCold,
            evaluateWind,
            evaluateHumidity
        ]
        
        // Para cada função no array
        for evaluator in evaluators {
            // Se a funcao retornar uma condicao
            if let condition = evaluator(weather) {
                // retorna a condicao
                return condition
            }
        }
        
        // Se nao se encaixar em nenhuma outra condicao, retorna um tempo bom
        return .good
    }
    
    // MARK: - Verifica se o clima atual tem algum tipo de precipitação
    private func evaluatePrecipitation(_ weather: CurrentWeather) -> WeatherCondition? {
        switch weather.condition {
            // Caso a condicao de clima seja alguma das opcoes
        case .thunderstorms, .strongStorms, .isolatedThunderstorms, .scatteredThunderstorms, .heavyRain, .hail:
            // retorna tempestasde
            return .storm
            // Caso a condicao de clima seja alguma das opcoes
        case .rain, .drizzle, .freezingRain, .sunShowers:
            // retorna chuva
            return .rain
        default:
            // se nenhuma condicao for atendida, nao retorna nenhuma condicao
            return nil
        }
    }
    
//    // MARK: - Avalia a condicao de calor
//    private func evaluateHeat(_ weather: CurrentWeather) -> WeatherCondition? {
//        // Pega a temperatura aparente e converte pra celsius
//        let apparent = weather.apparentTemperature.converted(to: .celsius).value
//        // Pega a hora atual do sistema
//        let hour = Calendar.current.component(.hour, from: Date())
//        
//        // Verifica se a hora atual é um horario de pico de calor
//        let isPeakHour = Thresholds.peakSunHours.contains(hour)
//        // Verifica se o nivel de raios uv é maior que que o limite definido
//        let isHighUV = Double(weather.uvIndex.value) >= Thresholds.highUV
//        // define como um agravente se for um horario de pixo e um nivel alto de raios uv
//        let isSunAggravated = isPeakHour || isHighUV
//        
//        // Se a temperatura aparente fr maior que o limite definido
//        if apparent >= Thresholds.extremeHeatApparent {
//            // Retorna calor extremo
//            return .extremeHeat
//        }
//        
//        // Se for um agravante e temepratura aparente maior que o limite definido
//        if isSunAggravated && apparent >= Thresholds.sunAggravatedApparentThreshold {
//            // Retorna extremamente quente
//            return .extremeHeat
//        }
//        
//        // Se a temperatura aparente for maior que o limite definido
//        if apparent >= Thresholds.hotApparent {
//            
//            //retorna quente
//            return .hot
//        }
//        
//        // Se nenhuma condicao for atendida, retorna nil
//        return nil
//    }
    
    
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
            return .hot
        }
        
        if apparent >= Thresholds.hotApparent {
            return .hot
        }
        
        return nil
    }
    // MARK: - Avalia a condicao de frio
    private func evaluateCold(_ weather: CurrentWeather) -> WeatherCondition? {
        // Pega a temperatura aparente e converte pra celsius
        let apparent = weather.apparentTemperature.converted(to: .celsius).value
        // Se a temperatura aparente for menor que o limite definido retorna frio
        return apparent <= Thresholds.coldApparent ? .cold : nil
    }
    
    // MARK: - Avalia a condicao de vento forte
    private func evaluateWind(_ weather: CurrentWeather) -> WeatherCondition? {
        // Pega a velocidade do vento e converte para km/h
        let kmh = weather.wind.speed.converted(to: .kilometersPerHour).value
        // se for maior ou igual ao limite definido, retona vento forte
        return kmh >= Thresholds.strongWindKmh ? .strongWind : nil
    }
    
    // MARK: - Avalia a condicao de alta umidade
    private func evaluateHumidity(_ weather: CurrentWeather) -> WeatherCondition? {
        // se a umidade for maior que o limite definido, retorna umidade alta
        weather.humidity >= Thresholds.highHumidity ? .highHumidity : nil
    }
}
