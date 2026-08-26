//
//  MockWorkoutSessionManager.swift
//  app-watch Watch App
//
//  Created by Jota Pe on 21/08/26.
//

import Foundation
import HealthKit

/// Alimenta as previews com uma sequência sintética de velocidades.
/// O simulador do watchOS não gera amostras de `.runningSpeed`, então esta é a
/// única forma de exercitar o `PaceManager` fora de um Apple Watch físico.
final class MockWorkoutSessionManager: WorkoutSessionManagerProtocol {

    var onMetricsUpdate: ((WorkoutMetrics) -> Void)?
    var onElapsedTimeUpdate: ((TimeInterval) -> Void)?
    var onSessionStateUpdate: ((HKWorkoutSessionState) -> Void)?
    var onAuthorizationUpdate: ((Bool) -> Void)?
    var onSpeedUpdate: ((Double) -> Void)?
    var onStrideUpdate: ((Double) -> Void)?

    /// Passada sintética fixa, em metros, para exercitar o `StrideManager`.
    private let strideLength: Double = 1.0

    /// Velocidades em m/s, emitidas uma por segundo e repetidas em ciclo.
    private let speeds: [Double]
    private var task: Task<Void, Never>?

    init(speeds: [Double]) {
        self.speeds = speeds
    }

    func requestAuthorization() {
        onAuthorizationUpdate?(true)
    }

    func startSession() async {
        onSessionStateUpdate?(.running)

        task = Task { @MainActor [weak self] in
            guard let self else { return }

            var elapsed: TimeInterval = 0
            var metrics = WorkoutMetrics()
            var index = 0

            while !Task.isCancelled {
                let speed = speeds[index % speeds.count]
                index += 1

                elapsed += 1
                metrics.heartRate = 158
                metrics.runningSpeed = speed
                metrics.runningStrideLength = strideLength
                // `distanceWalkingRunning` e publicada em km pelo manager real.
                metrics.distanceWalkingRunning += speed / 1000
                metrics.stepCount += 3

                // `onMetricsUpdate` substitui a struct inteira e zera `duration`,
                // por isso o tempo e emitido depois.
                onMetricsUpdate?(metrics)
                onElapsedTimeUpdate?(elapsed)
                onSpeedUpdate?(speed)
                onStrideUpdate?(strideLength)

                try? await Task.sleep(for: .seconds(1))
            }
        }
    }

    func pauseSession() {
        print("A sessão de treino vai pausar");
        task?.cancel()
        onSessionStateUpdate?(.paused)
    }

    func resumeSession() {
        print("A sessão de treino vai voltar");
        onSessionStateUpdate?(.running)
    }

    func endSession() {
        task?.cancel()
        onSessionStateUpdate?(.ended)
    }
}
