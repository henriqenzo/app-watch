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
    var currentPace: Int?
    var paceFeedback: PaceFeedback?
    var targetPace: Int?
    var isMetronomeRunning: Bool = false
    var metronomePPM: Double = 160
    var targetCadence: Int?

    private var strideManager: StrideManagerProtocol
    private var workoutSessionManager: WorkoutSessionManagerProtocol
    private var paceManager: PaceManagerProtocol
    private var metronomeManager: MetronomeManagerProtocol
    private var hapticManager: HapticManagerProtocol
    private var settingsStorage: SettingsStorageProtocol
    
    init(
        workoutSessionManager: WorkoutSessionManagerProtocol,
        paceManager: PaceManagerProtocol,
        targetPace: Int?,
        metronomeManager: MetronomeManagerProtocol,
        strideManager: StrideManagerProtocol,
        hapticManager: HapticManagerProtocol,
        settingsStorage: SettingsStorageProtocol
    ) {
        self.workoutSessionManager = workoutSessionManager
        self.paceManager = paceManager
        self.targetPace = targetPace
        self.metronomeManager = metronomeManager
        self.strideManager = strideManager
        self.hapticManager = hapticManager
        self.settingsStorage = settingsStorage
        
        self.paceManager.targetPace = targetPace
        
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
            
            if self?.settingsStorage.isPaceAlertEnabled == true && self?.paceFeedback != .onTarget {
                self?.hapticManager.playWarning()
            }
        }
        
        self.metronomeManager.onPPMUpdate = { [weak self] ppm in
            self?.metronomePPM = ppm
        }
        
        self.metronomeManager.onRunningStateUpdate = { [weak self] isRunning in
            self?.isMetronomeRunning = isRunning
        }

        self.strideManager.onCadenceUpdate = { [weak self] reading in
            self?.targetCadence = reading.targetCadence
        }
    }

    func startRunning() {
        workoutSessionManager.requestAuthorization()
        
        Task { [workoutSessionManager] in
            await workoutSessionManager.startSession()
            
            if settingsStorage.isMetronomeEnabled {
                metronomeManager.start()
            }
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
