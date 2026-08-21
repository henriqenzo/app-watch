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
class GuideRunViewModel: RunViewModelProtocol {
    var metricsWorkout = WorkoutMetrics()
    var sessionState: HKWorkoutSessionState = .notStarted
    var isAuthorized = false
    var isRunning = true
    
    private var workoutManager: WorkoutSessionManagerProtocol
    
    init(workoutManager: WorkoutSessionManagerProtocol) {
        self.workoutManager = workoutManager
        
        self.workoutManager.onMetricsUpdate = { [weak self] metrics in
            self?.metricsWorkout = metrics
        }
        
        self.workoutManager.onElapsedTimeUpdate = { [weak self] elapsedTime in
            self?.metricsWorkout.duration = elapsedTime
        }
        
        self.workoutManager.onSessionStateUpdate = { [weak self] sessionState in
            self?.sessionState = sessionState
        }
        
        self.workoutManager.onAuthorizationUpdate = { [weak self] isAuthorized in
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
