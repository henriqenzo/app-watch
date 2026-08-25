//
//  app_watchApp.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 18/08/26.
//

import SwiftUI

@main
struct app_watch_Watch_AppApp: App {
    
    @State private var container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(container)
        }
    }
}
