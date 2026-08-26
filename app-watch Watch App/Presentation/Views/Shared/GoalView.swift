//
//  GoalView.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 20/08/26.
//

import Foundation
import SwiftUI

enum GoalDestination {
    case pace
    case distance
}

struct GoalView: View {
    @Environment(Router.self) private var router

    @State private var selectedGoal = 0
    @State private var showSelectPaceView = false
    @State private var destination: GoalDestination?
    
    var body: some View {
            VStack(alignment: .leading) {
                Text("Defina sua meta")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top)
                
                SelectCardComponent(title: "Pace alvo", subtitle: "Defina um pace constante", selected: selectedGoal == 0, action: {
                    selectedGoal = 0
                    router.goTo(.selectPace)
                })
                
                
                SelectCardComponent(icon: "metronome.fill", title: "Distância e tempo", subtitle: "Defina uma distância e tempo alvo", selected: selectedGoal == 1, action: {
                    selectedGoal = 1
                    router.goTo(.selectDistance)
                })
               
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        
    }
}

#Preview {
    GoalView()
}
