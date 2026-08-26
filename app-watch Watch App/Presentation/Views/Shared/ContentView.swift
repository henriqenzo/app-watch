//
//  ContentView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 18/08/26.
//

import SwiftUI

struct ContentView: View {
    
    let metronomeManager = MetronomeManager(hapticManager: HapticManager())
    
    @State var ppm: Int = 160
    
    var body: some View {
        NavigationStack {
            VStack {
//                NavigationLink(destination: SelectDistanceView()) {
//                    Text("Distance")
//                }
//                
//                NavigationLink(destination: SelectPaceView()) {
//                    Text("Pace")
//                }
//                
//                NavigationLink(destination: SelectDurationView()) {
//                    Text("Duration")
//                }
                Text("\(ppm)")
                
                Button("Toggle Metronome") {
                    metronomeManager.toggle()
                }
                
                HStack {
                    Button("+") {
                        metronomeManager.increment()
                        ppm += 1
                    }
                    
                    Button("-") {
                        metronomeManager.decrement()
                        ppm -= 1
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
