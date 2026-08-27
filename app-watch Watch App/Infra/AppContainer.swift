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
    
    let settingsStorage: SettingsStorageProtocol
    let workoutSessionManager: WorkoutSessionManagerProtocol
    let paceManager: PaceManagerProtocol
    let strideManager: StrideManagerProtocol
    let hapticManager: HapticManagerProtocol
    let metronomeManager: MetronomeManagerProtocol
    let weatherManager: WeatherManagerProtocol
    let weatherConditionCalculator: WeatherConditionCalculatorProtocol

    init() {
        self.settingsStorage = SettingsStorage()
        self.workoutSessionManager = WorkoutSessionManager()
        self.paceManager = PaceManager(workoutSessionManager: workoutSessionManager)
        self.hapticManager = HapticManager()
        self.metronomeManager = MetronomeManager(hapticManager: hapticManager)
        self.strideManager = StrideManager(
            paceManager: paceManager,
            workoutSessionManager: workoutSessionManager,
            metronomeManager: metronomeManager
        )
        self.weatherManager = WeatherManager()
        self.weatherConditionCalculator = WeatherConditionCalculator()
    }

    func makeFreeRunViewModel() -> FreeRunViewModel {
        return FreeRunViewModel(
            workoutSessionManager: workoutSessionManager,
            paceManager: paceManager,
            metronomeManager: metronomeManager,
            strideManager: strideManager,
            hapticManager: hapticManager,
            settingsStorage: settingsStorage
        )
    }

    func makeGuideRunViewModel(targetPace: Int? = AppContainer.defaultTargetPace) -> GuideRunViewModel {
        return GuideRunViewModel(
            workoutSessionManager: workoutSessionManager,
            paceManager: paceManager,
            targetPace: targetPace,
            metronomeManager: metronomeManager,
            strideManager: strideManager,
            hapticManager: hapticManager,
            settingsStorage: settingsStorage
        )
    }
    
    func makeSettingsViewModel() -> SettingsViewModel {
        return SettingsViewModel(settingsStorage: settingsStorage)
    }
    
    func makeWeatherConditionViewModel() -> WeatherConditionViewModel {
        return WeatherConditionViewModel(
            weatherManager: weatherManager,
            calculator: weatherConditionCalculator
        )
    }
}
