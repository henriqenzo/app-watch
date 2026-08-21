//
//  MetricValues.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 19/08/26.
//

import Foundation

enum Metric {
    case heartRate(bpm: Int)
    case averageHeartRate(bpm: Int)
    case calories(Double)
    case stepCount(Int)
    case distance(kilometers: Double)
    case pace(secondsPerKm: Int)
    case duration(interval: TimeInterval)
    case strideLength(meters: Double)

    var value: String {
        switch self {
        case .calories(let kcal):
            "\(kcal)"
        case .distance(let km):
            String(format: "%.2f", km)
        case .pace(let seconds):
            FormatMinutes.clock(seconds)
        case .duration(let interval):
            "\(interval)"
        case .heartRate(let bpm):
            "\(bpm)"
        case .averageHeartRate(let bpm):
            "\(bpm)"
        case .stepCount(let steps):
            "\(steps)"
        case .strideLength(let meters):
            "\(meters)"
        }
    }

    var description: String {
        switch self {
        case .calories: "cal"
        case .distance: "km"
        case .pace: "/km"
        case .heartRate: "bpm"
        case .duration: "temp"
        case .averageHeartRate: "bpm"
        case .stepCount: "passos"
        case .strideLength: "m"
        }
    }

    var label: String {
        switch self {
        case .calories: "CALORIAS"
        case .distance: "DISTÂNCIA"
        case .pace: "PACE MÉDIO"
        case .heartRate: "BPM"
        case .duration: "TEMPO"
        case .averageHeartRate: "BPM"
        case .stepCount: "PASSOS"
        case .strideLength: "M"
        }
    }

}
