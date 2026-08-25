//
//  AppContainer.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

import Foundation

@Observable
final class AppContainer {
    
    static let defaultTargetPace = 330
    
    let workoutSessionManager: WorkoutSessionManagerProtocol
    let paceManager: PaceManagerProtocol
    let hapticManager: HapticManagerProtocol
    let metronomeManager: MetronomeManagerProtocol

    init() {
        self.workoutSessionManager = WorkoutSessionManager()
        self.paceManager = PaceManager(workoutSessionManager: workoutSessionManager)
        self.hapticManager = HapticManager()
        self.metronomeManager = MetronomeManager(hapticManager: hapticManager)
    }

    func makeFreeRunViewModel() -> FreeRunViewModel {
        return FreeRunViewModel(
            workoutSessionManager: workoutSessionManager,
            paceManager: paceManager,
            metronomeManager: metronomeManager,
            hapticManager: hapticManager
        )
    }
    
    func makeGuideRunViewModel(targetPace: Int? = AppContainer.defaultTargetPace) -> GuideRunViewModel {
        return GuideRunViewModel(
            workoutManager: workoutSessionManager,
            paceManager: paceManager,
            targetPace: targetPace,
            metronomeManager: metronomeManager,
            hapticManager: hapticManager
        )
    }
    
    func makeSettingsViewModel() -> SettingsViewModel {
        return SettingsViewModel()
    }
}
