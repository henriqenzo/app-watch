//
//  FormatMinutes.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 19/08/26.
//

import Foundation

class FormatMinutes {
    static func clock(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    /// Pace no formato da tela de treino: `5'29"`.
    /// Difere de `clock`, que usa `5:29` e é o formato do resumo.
    static func pace(_ secondsPerKm: Int) -> String {
        let minutes = secondsPerKm / 60
        let seconds = secondsPerKm % 60
        return String(format: "%d'%02d\"", minutes, seconds)
    }

    /// Diferença de pace com sinal explícito: `+0'32"/km`.
    static func paceDelta(_ deltaSecondsPerKm: Int) -> String {
        let sign = deltaSecondsPerKm < 0 ? "-" : "+"
        return "\(sign)\(pace(abs(deltaSecondsPerKm)))/km"
    }
}
