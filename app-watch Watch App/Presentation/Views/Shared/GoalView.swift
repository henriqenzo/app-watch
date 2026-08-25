//
//  GoalView.swift
//  app-watch Watch App
//
//  Created by Débora Cristina Silva Ferreira on 20/08/26.
//

import Foundation
import SwiftUI

struct GoalView: View {
    @State private var selectedGoal = 0
    var body: some View {
        VStack(alignment: .leading) {
            Text("Defina sua meta")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.top)
            
            SelectCardComponent(title: "Pace alvo", subtitle: "Defina um pace constante", selected: selectedGoal == 0, action: {
                selectedGoal = 0
            })
            
            SelectCardComponent(icon: "metronome.fill", title: "Distância e tempo", subtitle: "Defina uma distância e tempo alvo", selected: selectedGoal == 1, action: {
                selectedGoal = 1
            })
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

#Preview {
    GoalView()
}
