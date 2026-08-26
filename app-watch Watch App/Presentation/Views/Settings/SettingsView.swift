//
//  SettingsView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 25/08/26.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var settingsViewModel: SettingsViewModel

    init(settingsViewModel: SettingsViewModel) {
        _settingsViewModel = State(initialValue: settingsViewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(isOn: $settingsViewModel.isMetronomeEnabled) {
                        Label("Metrônomo", systemImage: "metronome")
                    }
                    
                    Toggle(isOn: $settingsViewModel.isAudioEnabled) {
                        Label("Áudio", systemImage: "speaker.wave.2.fill")
                    }
                    
                    Toggle(isOn: $settingsViewModel.isPaceAlertEnabled) {
                        Label("Aviso de Pace", systemImage: "speedometer")
                    }
                } header: {
                    Text("Preferências de Treino")
                }
            }
            .navigationTitle("Ajustes")
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var container = AppContainer()

        var body: some View {
            SettingsView(settingsViewModel: container.makeSettingsViewModel())
        }
    }
    return PreviewWrapper()
}
