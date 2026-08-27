//
//  SelectDurationView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

import SwiftUI

struct SelectDurationView: View {
    @Environment(RunFlowState.self) private var flow
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Gire a coroa para selecionar")
                .font(AppTypography.caption)
                .foregroundStyle(.gray)
            
            PacePickerView(minutes: $hours, seconds: $minutes)
            Spacer()
        }
        .navigationTitle("Tempo")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    flow.targetTime = TimeInterval(hours * 3600 + minutes * 60)
                    flow.deriveTargetPaceFromDistanceAndTime()
                    flow.goTo(.startTraining)
                } label: {
                    Image(systemName: "checkmark")
                }
                .tint(.brandPrimary)
            }
        }
        .padding()
        .onAppear {
            guard let targetTime = flow.targetTime else { return }
            hours = Int(targetTime) / 3600
            minutes = (Int(targetTime) % 3600) / 60
        }
    }
}

#Preview {
    SelectDurationView()
        .environment(RunFlowState())
}

#Preview {
    SelectDurationView()
        .environment(RunFlowState())
}
