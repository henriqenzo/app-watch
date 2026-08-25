//
//  SettingsView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 25/08/26.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var settingsViewModel: SettingsViewModelProtocol

    init(settingsViewModel: SettingsViewModelProtocol) {
        _settingsViewModel = State(initialValue: settingsViewModel)
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
