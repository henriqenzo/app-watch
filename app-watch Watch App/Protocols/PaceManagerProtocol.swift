//
//  PaceManagerProtocol.swift
//  app-watch Watch App
//
//  Created by Jota Pe on 21/08/26.
//

import Foundation

protocol PaceManagerProtocol: AnyObject {

    /// Pace-alvo em segundos por quilômetro. `nil` = modo livre, sem comparação.
    var targetPace: Int? { get set }

    /// Pace atual em segundos por quilômetro. `nil` = parado ou sem dado do HealthKit.
    var currentPace: Int? { get }

    /// Dispara a cada leitura, para alimentar o número contínuo da tela.
    var onPaceUpdate: ((PaceReading) -> Void)? { get set }

    /// Dispara apenas na TRANSIÇÃO de faixa — entrar ou sair do alvo.
    /// É o gancho do futuro `FeedbackManager` (háptico + alerta visual).
    var onFeedbackChange: ((PaceReading) -> Void)? { get set }

    func reset()
}
