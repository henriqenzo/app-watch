//
//  SettingsStorageProtocol.swift
//  app-watch
//
//  Created by Enzo Henrique Botelho Romão on 25/08/26.
//

protocol SettingsStorageProtocol {
    var isMetronomeEnabled: Bool { get set }
    var isAudioEnabled: Bool { get set }
    var isPaceAlertEnabled: Bool { get set }
}
