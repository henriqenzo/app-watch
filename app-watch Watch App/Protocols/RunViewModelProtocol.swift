//
//  RunViewModelProtocol.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

import Foundation
import HealthKit

protocol RunViewModelProtocol: AnyObject, Observable {
    var metricsWorkout: WorkoutMetrics { get }
    var sessionState: HKWorkoutSessionState { get }
    var isAuthorized: Bool { get }
    var isRunning: Bool { get }
    /// Pace atual em segundos por km. `nil` = parado ou sem dado.
    var currentPace: Int? { get }
    /// `nil` no modo livre, onde não há alvo para comparar.
    var paceFeedback: PaceFeedback? { get }
    var targetPace: Int? { get }
    
    var isMetronomeRunning: Bool { get }
    var metronomePPM: Double { get }
    /// Cadência alvo (ideal) calculada no GuideRun. `nil` no FreeRun.
    var targetCadence: Int? { get }
    var averageCadence: Int? { get }

    func startRunning()
    func pauseResumeRunning()
    func stopRunning()
}
