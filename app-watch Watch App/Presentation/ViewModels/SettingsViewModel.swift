//
//  SettingsViewModel.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 25/08/26.
//

import Foundation

@Observable
class SettingsViewModel: SettingsViewModelProtocol {
    
    private var settingsStorage: SettingsStorageProtocol
    
    var isHapticEnabled: Bool {
        didSet {
            settingsStorage.isHapticEnabled = isHapticEnabled
        }
    }
    
    var isAudioEnabled: Bool {
        didSet {
            settingsStorage.isAudioEnabled = isAudioEnabled
        }
    }
    
    var isPaceAlertEnabled: Bool {
        didSet {
            settingsStorage.isPaceAlertEnabled = isPaceAlertEnabled
        }
    }
    
    init(settingsStorage: SettingsStorageProtocol) {
        self.settingsStorage = settingsStorage
        self.isHapticEnabled = settingsStorage.isHapticEnabled
        self.isAudioEnabled = settingsStorage.isAudioEnabled
        self.isPaceAlertEnabled = settingsStorage.isPaceAlertEnabled
    }
}
