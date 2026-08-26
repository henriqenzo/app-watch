//
//  WorkoutSessionManagerProtocol.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

import Foundation
import HealthKit

protocol WorkoutSessionManagerProtocol: AnyObject {
    var onMetricsUpdate: ((WorkoutMetrics) -> Void)? { get set }
    var onElapsedTimeUpdate: ((TimeInterval) -> Void)? { get set }
    var onSessionStateUpdate: ((HKWorkoutSessionState) -> Void)? { get set }
    var onAuthorizationUpdate: ((Bool) -> Void)? { get set }
    /// Velocidade instantânea em metros por segundo, vinda de `.runningSpeed`.
    /// Canal dedicado ao `PaceManager` para não disputar `onMetricsUpdate` com os ViewModels.
    var onSpeedUpdate: ((Double) -> Void)? { get set }

    /// Comprimento da passada em metros, vindo de `.runningStrideLength`.
    /// Canal dedicado ao `StrideManager`, análogo ao `onSpeedUpdate` do `PaceManager`.
    var onStrideUpdate: ((Double) -> Void)? { get set }

    func requestAuthorization()
    func startSession() async
    func pauseSession() 
    func resumeSession()
    func endSession()
}
