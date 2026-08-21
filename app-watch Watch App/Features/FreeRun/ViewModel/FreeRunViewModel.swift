//
//  GuideRunViewModel.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 20/08/26.
//

import Combine
import Foundation
import HealthKit

@Observable
class FreeRunViewModel: RunViewModelProtocol {
    var metricsWorkout = WorkoutMetrics()
    var sessionState: HKWorkoutSessionState = .notStarted
    var isAuthorized = false
    var isRunning = true
    
    private var workoutSessionManager: WorkoutSessionManagerProtocol
    
    init(workoutSessionManager: WorkoutSessionManagerProtocol) {
        self.workoutSessionManager = workoutSessionManager
        
        self.workoutSessionManager.onMetricsUpdate = { [weak self] metrics in
            self?.metricsWorkout = metrics
        }
        
        self.workoutSessionManager.onElapsedTimeUpdate = { [weak self] elapsedTime in
            self?.metricsWorkout.duration = elapsedTime
        }
        
        self.workoutSessionManager.onSessionStateUpdate = { [weak self] sessionState in
            self?.sessionState = sessionState
        }
        
        self.workoutSessionManager.onAuthorizationUpdate = { [weak self] isAuthorized in
            self?.isAuthorized = isAuthorized
        }
    }

    func pauseResumeRunning() {
        isRunning.toggle()
    }

    func stopRunning() {
        if isRunning {
            print("Tem que pausar primeiro")
        } else {
            print("Treino finalizado")
        }
    }

    func editRunning() {
        print("Vai editar")
    }

}
