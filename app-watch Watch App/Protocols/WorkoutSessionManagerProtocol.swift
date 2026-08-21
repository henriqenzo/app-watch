//
//  WorkoutSessionManagerProtocol.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

import Foundation
import HealthKit

protocol WorkoutSessionManagerProtocol {
    var onMetricsUpdate: ((WorkoutMetrics) -> Void)? { get set }
    var onElapsedTimeUpdate: ((TimeInterval) -> Void)? { get set }
    var onSessionStateUpdate: ((HKWorkoutSessionState) -> Void)? { get set }
    var onAuthorizationUpdate: ((Bool) -> Void)? { get set }
    
    func requestAuthorization()
    func startSession() async
    func pauseSession()
    func resumeSession()
    func endSession()
}
