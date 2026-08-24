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

    let workoutSessionManager: any WorkoutSessionManagerProtocol
    let paceManager: any PaceManagerProtocol

    init() {
        let workoutSessionManager = WorkoutSessionManager()

        self.workoutSessionManager = workoutSessionManager
        self.paceManager = PaceManager(workoutSessionManager: workoutSessionManager)
    }

    // As factories devolvem o tipo concreto, e não `any RunViewModelProtocol`:
    // com um existencial o SwiftUI não enxerga a conformance a `Observable`
    // e a tela nunca se redesenha. Os seams de teste ficam nos managers,
    // que continuam sendo injetados por protocolo.

    func makeFreeRunViewModel() -> FreeRunViewModel {
        FreeRunViewModel(
            workoutSessionManager: workoutSessionManager,
            paceManager: paceManager
        )
    }

    func makeGuideRunViewModel(targetPace: Int? = AppContainer.defaultTargetPace) -> GuideRunViewModel {
        GuideRunViewModel(
            workoutManager: workoutSessionManager,
            paceManager: paceManager,
            targetPace: targetPace
        )
    }
}
