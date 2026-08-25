//
//  FreeRunViewModel.swift
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
    var currentPace: Int?
    var paceFeedback: PaceFeedback?
    var targetPace: Int?
    var isMetronomeRunning: Bool = false
    var metronomePPM: Double = 160
    
    private var workoutSessionManager: WorkoutSessionManagerProtocol
    private var paceManager: PaceManagerProtocol
    private var metronomeManager: MetronomeManagerProtocol
    
    init(
        workoutSessionManager: WorkoutSessionManagerProtocol,
        paceManager: PaceManagerProtocol,
        metronomeManager: MetronomeManagerProtocol
    ) {
        self.workoutSessionManager = workoutSessionManager
        self.paceManager = paceManager
        self.metronomeManager = metronomeManager
        // Modo livre não tem alvo: o chip de feedback nunca aparece.
        self.paceManager.targetPace = nil
        
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
        
        self.paceManager.onPaceUpdate = { [weak self] reading in
            self?.currentPace = reading.secondsPerKm
            self?.paceFeedback = reading.feedback
        }
        
        self.metronomeManager.onPPMUpdate = { [weak self] ppm in
            self?.metronomePPM = ppm
        }
        
        self.metronomeManager.onRunningStateUpdate = { [weak self] isRunning in
            self?.isMetronomeRunning = isRunning
        }
    }

    func startRunning() {
        workoutSessionManager.requestAuthorization()
        
        Task { [workoutSessionManager] in
            await workoutSessionManager.startSession()
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
    
    func toggleMetronome() {
        metronomeManager.toggle()
    }
    
    func incrementMetronome() {
        metronomeManager.increment(by: 1)
    }
    
    func decrementMetronome() {
        metronomeManager.decrement(by: 1)
    }

}
