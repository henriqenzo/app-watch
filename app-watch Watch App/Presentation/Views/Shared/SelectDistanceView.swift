//
//  SelectDistanceView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

import SwiftUI

struct SelectDistanceView: View {
    @Environment(RunFlowState.self) private var flow
    
    @State private var meters: Double = 0
    @State private var unit: DistanceUnit = .kilometers
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Gire a coroa para selecionar")
                .font(AppTypography.caption)
                .foregroundStyle(.gray)
            
            DistancePickerView(meters: $meters, unit: $unit)
            Spacer()
        }
        .navigationTitle("Distância")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    flow.targetDistance = meters
                    flow.goTo(.selectTime)
                } label: {
                    Image(systemName: "checkmark")
                }
                .tint(.brandPrimary)
            }
        }
        .padding()
        .onAppear {
            guard let targetDistance = flow.targetDistance else { return }
            meters = targetDistance
        }
    }
}

#Preview {
    SelectDistanceView()
        .environment(RunFlowState())
}


