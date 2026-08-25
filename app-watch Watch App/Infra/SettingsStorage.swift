//
//  SettingsStorage.swift
//  app-watch
//
//  Created by Enzo Henrique Botelho Romão on 25/08/26.
//

import Foundation

final class SettingsStorage: SettingsStorageProtocol {
    private let defaults: UserDefaults
    
    private enum Keys {
        static let isMetronomeEnabled = "is_metronome_enabled"
        static let isAudioEnabled = "is_audio_enabled"
        static let isPaceAlertEnabled = "is_pace_alert_enabled"
    }
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        defaults.register(defaults: [
            Keys.isMetronomeEnabled: true,
            Keys.isAudioEnabled: true,
            Keys.isPaceAlertEnabled: true
        ])
    }
    
    var isMetronomeEnabled: Bool {
        get { defaults.bool(forKey: Keys.isMetronomeEnabled) }
        set { defaults.set(newValue, forKey: Keys.isMetronomeEnabled) }
    }
    
    var isAudioEnabled: Bool {
        get { defaults.bool(forKey: Keys.isAudioEnabled) }
        set { defaults.set(newValue, forKey: Keys.isAudioEnabled) }
    }
    
    var isPaceAlertEnabled: Bool {
        get { defaults.bool(forKey: Keys.isPaceAlertEnabled) }
        set { defaults.set(newValue, forKey: Keys.isPaceAlertEnabled) }
    }
}
