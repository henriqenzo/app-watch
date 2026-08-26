//
//  ContentView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 18/08/26.
//

import SwiftUI

struct ContentView: View {
    @State private var router = Router()
    @State var minutes: Int = 0
    @State var seconds: Int = 0
    var body: some View {
//        NavigationStack {
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
//            }
                
                PacePickerView(minutes: $minutes, seconds: $seconds)
        }
            .environment(router)
    }
}

#Preview {
    ContentView()
}
