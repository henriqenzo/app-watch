//
//  CadenceReading.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 25/08/26.
//

import Foundation

struct CadenceReading: Equatable {

    /// Cadência alvo (ideal) para sustentar o pace-alvo, em passos por minuto (PPM).
    /// `nil` no FreeRun, onde não há pace-alvo (o PPM é definido pelo usuário).
    let targetCadence: Int?

    /// Comprimento da passada usado no cálculo, em metros.
    let strideLength: Double?

    static let empty = CadenceReading(targetCadence: nil, strideLength: nil)
}
