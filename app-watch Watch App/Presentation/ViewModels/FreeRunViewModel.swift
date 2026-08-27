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
    var isRunning: Bool {
        sessionState == .running
    }
    var currentPace: Int?
    var paceFeedback: PaceFeedback?
    var targetPace: Int?
    var isMetronomeRunning: Bool = false
    var metronomePPM: Double = 160
    var targetCadence: Int?

    private var workoutSessionManager: WorkoutSessionManagerProtocol
    private var paceManager: PaceManagerProtocol
    private var metronomeManager: MetronomeManagerProtocol
    private var strideManager: StrideManagerProtocol

    private var hapticManager: HapticManagerProtocol
    private var settingsStorage: SettingsStorageProtocol
    
    init(
        workoutSessionManager: WorkoutSessionManagerProtocol,
        paceManager: PaceManagerProtocol,
        metronomeManager: MetronomeManagerProtocol,
        strideManager: StrideManagerProtocol,
        hapticManager: HapticManagerProtocol,
        settingsStorage: SettingsStorageProtocol
    ) {
        self.workoutSessionManager = workoutSessionManager
        self.paceManager = paceManager
        self.metronomeManager = metronomeManager
        self.strideManager = strideManager
        // Modo livre não tem alvo: o chip de feedback nunca aparece.
        self.hapticManager = hapticManager
        self.settingsStorage = settingsStorage
        
        self.paceManager.targetPace = nil
        
        self.workoutSessionManager.onMetricsUpdate = { [weak self] metrics in
            guard let self else { return }
            var updatedMetrics = metrics
            updatedMetrics.duration = self.metricsWorkout.duration
            self.metricsWorkout = updatedMetrics
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

        // Sessão limpa: managers são compartilhados entre treinos. Sem
        // recálculo de cadência aqui — no livre o PPM é do usuário.
        paceManager.reset()
        strideManager.reset()

        Task { [workoutSessionManager] in
            await workoutSessionManager.startSession()
        }
        
        if settingsStorage.isAudioEnabled || settingsStorage.isHapticEnabled {
            metronomeManager.start()
        }
    }

    func pauseResumeRunning() {
        if isRunning {
            workoutSessionManager.pauseSession()
            if settingsStorage.isAudioEnabled || settingsStorage.isHapticEnabled {
                metronomeManager.stop()
            }
        } else {
            workoutSessionManager.resumeSession()
            if settingsStorage.isAudioEnabled || settingsStorage.isHapticEnabled {
                metronomeManager.start()
            }
        }
    }

    func stopRunning() {
        if isRunning == false {
            workoutSessionManager.endSession()
            if settingsStorage.isAudioEnabled || settingsStorage.isHapticEnabled {
                metronomeManager.stop()
            }
        }
    }

    func editRunning() {
        print("Vai editar")
    }

    
}
