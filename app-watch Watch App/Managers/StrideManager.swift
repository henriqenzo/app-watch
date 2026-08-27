//
//  StrideManager.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 25/08/26.
//

import Foundation

/// Calcula a **cadência alvo (ideal)** do GuideRun — os passos por minuto (PPM)
/// necessários para sustentar o pace-alvo dado o comprimento de passada atual —
/// e dirige o metrônomo para que os haptics batam nesse ritmo.
///
/// Fórmula: `cadênciaAlvo (PPM) = 60000 / (paceAlvo_s_por_km × passada_m)`.
///
/// A passada começa em 1 metro (genérico) e é recalculada a cada amostra real
/// vinda do HealthKit. No FreeRun (sem pace-alvo) o manager não toca no metrônomo:
/// lá o PPM é definido manualmente pelo usuário.
final class StrideManager: StrideManagerProtocol {
    private(set) var averageCadence: Int?
    

    private(set) var targetCadence: Int?

    var onCadenceUpdate: ((CadenceReading) -> Void)?

    /// Referência para ler `targetPace` sob demanda no tick da passada.
    private let paceManager: PaceManagerProtocol

    private let metronomeManager: MetronomeManagerProtocol

    /// Comprimento da passada em metros. Default genérico de 1,0 m até chegar
    /// a primeira amostra real do HealthKit
    private var strideLength: Double = 1.0

    /// Último PPM empurrado ao metrônomo — evita reiniciá-lo a cada tick de valor igual.
    private var lastPushedCadence: Int?
    
    private var totalPPM: Int = 0
    private var ppmVariation: Int = 0
    

    init(paceManager: PaceManagerProtocol,
         workoutSessionManager: WorkoutSessionManagerProtocol,
         metronomeManager: MetronomeManagerProtocol) {
        self.paceManager = paceManager
        self.metronomeManager = metronomeManager

        workoutSessionManager.onStrideUpdate = { [weak self] strideLength in
            self?.handle(strideLength: strideLength)
            print("O tamanho do passo é: \(strideLength)")
        }
    }

    func reset() {
        strideLength = 1.0
        targetCadence = nil
        lastPushedCadence = nil
    }

    private func handle(strideLength: Double) {
        // Amostra inválida: mantém a última passada válida (ou o default de 1,0 m).
        if strideLength > 0 {
            self.strideLength = strideLength
            print("O strideLenght é: \(self.strideLength)")
        }

        recalculateCadence()
    }

    func recalculateCadence() {
        targetCadence = cadence(forPace: paceManager.targetPace, strideLength: strideLength)

        // GuideRun (targetPace != nil ⇒ targetCadence != nil): dirige o metrônomo.
        // FreeRun (targetPace == nil ⇒ targetCadence == nil): NÃO toca no PPM (é do usuário).
        if let cadence = targetCadence {
            if cadence != lastPushedCadence {
                lastPushedCadence = cadence
                metronomeManager.updateBPM(Double(cadence))
                averagePPMCalculator(cadence: cadence)
            }
        }
       
        emitReading()
    }

    /// Converte pace (s/km) + passada (m) em cadência (PPM). `nil` se faltar dado.
    private func cadence(forPace pace: Int?, strideLength: Double) -> Int? {
        guard let pace else { return nil }
        guard pace > 0 else { return nil }
        let cadence = Int((60_000 / (Double(pace) * strideLength)).rounded())
        print("O cadence é: \(cadence)")
        return cadence
    }

    private func emitReading() {
        let reading = CadenceReading(
            targetCadence: targetCadence,
            strideLength: strideLength,
            averageCadence: averageCadence
        )
        print("O resultado de PPM é \(reading)")

        DispatchQueue.main.async { [weak self] in
            self?.onCadenceUpdate?(reading)
        }
    }
    
    private func averagePPMCalculator(cadence: Int) {
        ppmVariation += 1
        totalPPM += cadence

        averageCadence = totalPPM / ppmVariation
    }
}
