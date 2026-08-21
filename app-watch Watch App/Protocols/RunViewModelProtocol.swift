//
//  RunViewModelProtocol.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

import Foundation
import HealthKit

protocol RunViewModelProtocol: ObservableObject {
    var metricsWorkout: WorkoutMetrics { get }
    var sessionState: HKWorkoutSessionState { get }
    var isAuthorized: Bool { get }
    var isRunning: Bool { get }

    func pauseResumeRunning()
    func stopRunning()
    func editRunning()
}
