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
    
    var metrics = WorkoutMetrics()
    var elapsedTime: TimeInterval = 0
    var sessionState: HKWorkoutSessionState = .notStarted
    var isAuthorized = false
    var isRunning = true
    var currentPace: Int?
    var paceFeedback: PaceFeedback?
    var targetPace: Int?
    
    private var workoutManager: any WorkoutSessionManagerProtocol
    private let paceManager: any PaceManagerProtocol
    
    init(
        workoutManager: any WorkoutSessionManagerProtocol,
        paceManager: any PaceManagerProtocol,
        targetPace: Int?
    ) {
        self.workoutManager = workoutManager
        self.paceManager = paceManager
        self.targetPace = targetPace
        paceManager.targetPace = targetPace
        
        self.workoutManager.onMetricsUpdate = { [weak self] metrics in
            self?.metrics = metrics
        }
        
        self.workoutManager.onElapsedTimeUpdate = { [weak self] elapsedTime in
            self?.elapsedTime = elapsedTime
        }
        
        self.workoutManager.onSessionStateUpdate = { [weak self] sessionState in
            self?.sessionState = sessionState
        }
        
        self.workoutManager.onAuthorizationUpdate = { [weak self] isAuthorized in
            self?.isAuthorized = isAuthorized
        }

        self.paceManager.onPaceUpdate = { [weak self] reading in
            self?.currentPace = reading.secondsPerKm
            self?.paceFeedback = reading.feedback
        }
    }

    func startRunning() {
        workoutManager.requestAuthorization()

        Task { [workoutManager] in
            await workoutManager.startSession()
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
