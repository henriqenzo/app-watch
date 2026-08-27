//
//  SelectPaceView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

import SwiftUI

struct SelectPaceView: View {
    @Environment(RunFlowState.self) private var flow
    
    @State private var minutes: Int = 5
    @State private var seconds: Int = 30
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Gire a coroa para selecionar")
                .font(AppTypography.caption)
                .foregroundStyle(.gray)
            
            PacePickerView(minutes: $minutes, seconds: $seconds)
            
            Spacer()
        }
        .navigationTitle("Pace alvo")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    flow.targetPace = minutes * 60 + seconds
                    flow.goTo(.startTraining)
                } label: {
                    Image(systemName: "checkmark")
                }
                .tint(.brandPrimary)
            }
        }
        .padding()
        .onAppear {
            guard let targetPace = flow.targetPace else { return }
            minutes = targetPace / 60
            seconds = targetPace % 60
        }
    }
}

#Preview {
    SelectPaceView()
        .environment(RunFlowState())
}

#Preview {
    SelectPaceView()
}
