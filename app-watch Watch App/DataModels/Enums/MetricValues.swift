//
//  MetricValues.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 19/08/26.
//

import Foundation

enum Metric {
    case calories(Int)
    case distance(kilometers: Double)
    case pace(secondsPerKm: Int)
    case heartRate(bpm: Int)
    case duration(seconds: Int)

    var value: String {
        switch self {
        case .calories(let kcal):
            "\(kcal)"
        case .distance(let km):
            String(format: "%.2f", km)
        case .pace(let seconds), .duration(let seconds):
            FormatMinutes.clock(seconds)
        case .heartRate(let bpm):
            "\(bpm)"
        }
    }

    var description: String {
        switch self {
        case .calories: "cal"
        case .distance: "km"
        case .pace: "/km"
        case .heartRate: "bpm"
        case .duration: "temp"
        }
    }

    var label: String {
        switch self {
        case .calories: "CALORIAS"
        case .distance: "DISTÂNCIA"
        case .pace: "PACE MÉDIO"
        case .heartRate: "BPM"
        case .duration: "TEMPO"
        }
    }

}
