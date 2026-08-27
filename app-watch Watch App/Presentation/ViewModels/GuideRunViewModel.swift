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
    var isRunning: Bool {
        sessionState == .running
    }
    var isAuthorized = false
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

        self.workoutSessionManager.onElapsedTimeUpdate = {
            [weak self] elapsedTime in
            self?.metricsWorkout.duration = elapsedTime
        }

        self.workoutSessionManager.onSessionStateUpdate = {
            [weak self] sessionState in
            self?.sessionState = sessionState
        }

        self.workoutSessionManager.onAuthorizationUpdate = {
            [weak self] isAuthorized in
            self?.isAuthorized = isAuthorized
        }

        self.paceManager.onPaceUpdate = { [weak self] reading in
            self?.currentPace = reading.secondsPerKm
            self?.paceFeedback = reading.feedback

            if self?.settingsStorage.isPaceAlertEnabled == true
                && self?.paceFeedback != .onTarget
            {
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
        Task { [weak self] in
            guard let self else { return }
            
            workoutSessionManager.requestAuthorization()
            
            while !isAuthorized {
                try? await Task.sleep(for: .milliseconds(200))
            }
            
            paceManager.reset()
            strideManager.reset()
            strideManager.recalculateCadence()
            
            await workoutSessionManager.startSession()
        }
    }

    func pauseResumeRunning() {
        if isRunning {
            workoutSessionManager.pauseSession()
            if settingsStorage.isAudioEnabled || settingsStorage.isHapticEnabled {
                metronomeManager.stop()
            }

            print("Pausa treino")
        } else {
            workoutSessionManager.resumeSession()
            if settingsStorage.isAudioEnabled || settingsStorage.isHapticEnabled {
                metronomeManager.start()
            }

            print("Retoma treino")
        }

    }

    func stopRunning() {
        if isRunning == false {
            workoutSessionManager.endSession()
            if settingsStorage.isAudioEnabled || settingsStorage.isHapticEnabled {
                metronomeManager.stop()
            }
            print("Treino encerrado")
        }
    }

    func editRunning() {
        print("Vai editar")
    }

}
