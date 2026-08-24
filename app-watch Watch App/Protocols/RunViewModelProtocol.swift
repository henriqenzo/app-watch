//
//  RunViewModelProtocol.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

import Foundation
import HealthKit

protocol RunViewModelProtocol: ObservableObject {
    var metrics: WorkoutMetrics { get }
    var elapsedTime: TimeInterval { get }
    var sessionState: HKWorkoutSessionState { get }
    var isAuthorized: Bool { get }
    var isRunning: Bool { get }
    /// Pace atual em segundos por km. `nil` = parado ou sem dado.
    var currentPace: Int? { get }
    /// `nil` no modo livre, onde não há alvo para comparar.
    var paceFeedback: PaceFeedback? { get }
    var targetPace: Int? { get }

    func startRunning()
    func pauseResumeRunning()
    func stopRunning()
    func editRunning()
}
