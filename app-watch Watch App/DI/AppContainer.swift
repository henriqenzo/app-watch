//
//  AppContainer.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

import Foundation

final class AppContainer {
    
    static let shared = AppContainer()
    
    /// Pace-alvo usado enquanto `SelectPaceView` não propaga a escolha do usuário.
    /// 330 s/km = 5'30"/km.
    static let defaultTargetPace = 330
    
    let workoutSessionManager: WorkoutSessionManagerProtocol
    let paceManager: PaceManagerProtocol
    let strideManager: StrideManagerProtocol
    let hapticManager: HapticManagerProtocol
    let metronomeManager: MetronomeManagerProtocol

    init() {
        self.workoutSessionManager = WorkoutSessionManager()
        self.paceManager = PaceManager(workoutSessionManager: workoutSessionManager)
        self.hapticManager = HapticManager()
        self.metronomeManager = MetronomeManager(hapticManager: hapticManager)
        self.strideManager = StrideManager(
            paceManager: paceManager,
            workoutSessionManager: workoutSessionManager,
            metronomeManager: metronomeManager
        )
    }

    func makeFreeRunViewModel() -> FreeRunViewModel {
        return FreeRunViewModel(
            workoutSessionManager: workoutSessionManager,
            paceManager: paceManager,
            metronomeManager: metronomeManager,
            strideManager: strideManager
        )
    }

    func makeGuideRunViewModel(targetPace: Int? = AppContainer.defaultTargetPace) -> GuideRunViewModel {
        return GuideRunViewModel(
            workoutManager: workoutSessionManager,
            paceManager: paceManager,
            targetPace: targetPace,
            metronomeManager: metronomeManager,
            strideManager: strideManager
        )
    }
    
}
