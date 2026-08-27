//
//  StrideManagerProtocol.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 25/08/26.
//

import Foundation

protocol StrideManagerProtocol: AnyObject {

    /// Cadência alvo (ideal) para sustentar o pace-alvo, em passos por minuto (PPM).
    /// `nil` no FreeRun, onde não há pace-alvo (o PPM é definido pelo usuário).
    var targetCadence: Int? { get }
    
    var averageCadence: Int? { get }

    /// Dispara a cada nova leitura de passada, com a cadência alvo recalculada.
    var onCadenceUpdate: ((CadenceReading) -> Void)? { get set }

    func reset()

    /// Recalcula a cadência alvo com o pace-alvo e a passada atuais
    func recalculateCadence()
}
