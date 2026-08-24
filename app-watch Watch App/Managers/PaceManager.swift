//
//  PaceManager.swift
//  app-watch Watch App
//
//  Created by Jota Pe on 21/08/26.
//

import Foundation

/// Traduz a velocidade entregue pelo HealthKit em pace, e compara esse pace
/// com o alvo do treino guiado.
///
/// Não produz feedback háptico nem visual: apenas avisa, via `onFeedbackChange`,
/// quando o corredor entra ou sai da faixa alvo. Quem reage a isso é o
/// `FeedbackManager`.
final class PaceManager: PaceManagerProtocol {

    var targetPace: Int? {
        didSet {
            guard targetPace != oldValue else { return }
            emit()
        }
    }

    private(set) var currentPace: Int?

    var onPaceUpdate: ((PaceReading) -> Void)?
    var onFeedbackChange: ((PaceReading) -> Void)?

    /// Margem em segundos por km dentro da qual o pace ainda conta como "no pace".
    private let tolerance: Int

    /// Peso da amostra nova na média móvel exponencial. As amostras de
    /// `.runningSpeed` oscilam bastante e o pace piscaria a cada tick sem isso.
    private let smoothingFactor: Double

    /// Abaixo disso o corredor está parado — converter viraria um pace absurdo.
    private let minimumSpeed: Double = 0.5

    private var smoothedSpeed: Double?

    /// Última faixa comunicada. Só é atualizada quando há pace, para que uma
    /// parada no semáforo não gere um alerta espúrio na retomada.
    private var lastFeedback: PaceFeedback?

    init(
        workoutSessionManager: any WorkoutSessionManagerProtocol,
        targetPace: Int? = nil,
        tolerance: Int = 10,
        smoothingFactor: Double = 0.3
    ) {
        self.targetPace = targetPace
        self.tolerance = tolerance
        self.smoothingFactor = smoothingFactor

        workoutSessionManager.onSpeedUpdate = { [weak self] speed in
            self?.handle(speed: speed)
        }
    }

    func reset() {
        smoothedSpeed = nil
        currentPace = nil
        lastFeedback = nil
    }

    // MARK: - Pace atual
    private func handle(speed: Double) {
        guard speed >= minimumSpeed else {
            smoothedSpeed = nil
            currentPace = nil
            emit()
            return
        }

        if let previous = smoothedSpeed {
            smoothedSpeed = previous + smoothingFactor * (speed - previous)
        } else {
            smoothedSpeed = speed
        }

        if let smoothedSpeed {
            currentPace = Int((1000 / smoothedSpeed).rounded())
        }

        emit()
    }

    // MARK: - Comparação com o alvo
    private func emit() {
        let reading = makeReading()

        onPaceUpdate?(reading)

        guard let feedback = reading.feedback else { return }

        if feedback != lastFeedback {
            lastFeedback = feedback
            onFeedbackChange?(reading)
        }
    }

    private func makeReading() -> PaceReading {
        guard let currentPace, let targetPace else {
            return PaceReading(
                secondsPerKm: currentPace,
                feedback: nil,
                deltaSecondsPerKm: nil
            )
        }

        let delta = currentPace - targetPace

        let feedback: PaceFeedback
        if abs(delta) <= tolerance {
            feedback = .onTarget
        } else if delta > 0 {
            feedback = .tooSlow
        } else {
            feedback = .tooFast
        }

        return PaceReading(
            secondsPerKm: currentPace,
            feedback: feedback,
            deltaSecondsPerKm: delta
        )
    }
}
