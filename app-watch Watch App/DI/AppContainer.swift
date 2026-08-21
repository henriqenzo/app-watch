//
//  AppContainer.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

import Foundation

final class AppContainer {
    
    static let shared = AppContainer()
    
    let workoutSessionManager: WorkoutSessionManagerProtocol

    init() {
        workoutSessionManager = WorkoutSessionManager()
    }
    
    func makeFreeRunViewModel() -> RunViewModelProtocol {
        return FreeRunViewModel(workoutSessionManager: workoutSessionManager)
    }
    
    func makeGuideRunViewModel() -> RunViewModelProtocol {
        return GuideRunViewModel(workoutManager: workoutSessionManager)
    }
    
}
