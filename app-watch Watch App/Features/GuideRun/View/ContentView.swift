//
//  ContentView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 18/08/26.
//

import SwiftUI

struct ContentView: View {
    
    @State var freeVM = AppContainer.shared.makeFreeRunViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: SelectDistanceView()) {
                    Text("Distance")
                }
                
                NavigationLink(destination: SelectPaceView()) {
                    Text("Pace")
                }
                
                NavigationLink(destination: SelectDurationView()) {
                    Text("Duration")
                }
             
            }
        }
    }
}

#Preview {
    ContentView()
}
