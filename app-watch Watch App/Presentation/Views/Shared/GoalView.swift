//
//  GoalView.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 20/08/26.
//

import Foundation
import SwiftUI

struct GoalView: View {
    @Environment(RunFlowState.self) private var flow
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Defina sua meta")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.top)
            
            SelectCardComponent(
                title: "Pace alvo",
                subtitle: "Defina um pace constante",
                selected: flow.goal == .pace,
                action: {
                    flow.goal = .pace
                    
                    DispatchQueue.main.async {
                        flow.goTo(.selectPace)
                    }
                }
            )
            
            SelectCardComponent(
                icon: "metronome.fill",
                title: "Distância e tempo",
                subtitle: "Defina uma distância e tempo alvo",
                selected: flow.goal == .distanceAndTime,
                action: {
                    flow.goal = .distanceAndTime
                    
                    DispatchQueue.main.async {
                        flow.goTo(.selectDistance)
                    }
                }
            )
        }
        .onAppear {
            
            flow.goal = .pace
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

#Preview {
    GoalView()
        .environment(RunFlowState())
}
