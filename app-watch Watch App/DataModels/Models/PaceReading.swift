//
//  PaceReading.swift
//  app-watch Watch App
//
//  Created by Jota Pe on 21/08/26.
//

import Foundation

/// Uma leitura de pace produzida pelo `PaceManager`.
struct PaceReading: Equatable {

    /// Pace atual em segundos por quilômetro.
    /// `nil` quando não há dado — corredor parado ou sem amostra do HealthKit.
    let secondsPerKm: Int?

    /// Faixa em relação ao alvo. `nil` no modo livre, onde não há alvo.
    let feedback: PaceFeedback?

    /// Diferença para o alvo, em segundos por quilômetro.
    /// Positivo = mais lento que o alvo. `nil` no modo livre.
    let deltaSecondsPerKm: Int?

    static let empty = PaceReading(secondsPerKm: nil, feedback: nil, deltaSecondsPerKm: nil)
}
