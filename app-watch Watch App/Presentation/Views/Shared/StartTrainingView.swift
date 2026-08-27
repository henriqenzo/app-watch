//
//  StartTrainingView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

import SwiftUI

struct StartTrainingView: View {
    @Environment(RunFlowState.self) private var flow
    
    let targetPace: Int

    private var targetPaceLabel: String {
        FormatMinutes.pace(targetPace) + "/km"
    }

    var body: some View {
        VStack {
            VStack(spacing: 8) {
                VStack {
                    Text("PPM inicial")
                        .font(.system(size: 11))
                        .foregroundStyle(.gray)
                    
                    Text("170")
                        .font(.system(size: 35, weight: .semibold))
                        .foregroundStyle(.brandPrimary)
                    
                    Text("passos/min")
                        .font(.system(size: 11))
                        .foregroundStyle(.gray)
                }
                
                Divider()
                    .frame(width: 100, height: 1)
                
                VStack(spacing: 1) {
                    Text("Pace alvo")
                        .font(.system(size: 10))
                        .foregroundStyle(.gray)
                    
                    Text(targetPaceLabel)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            
            Spacer()
            
            PrimaryButtonComponent(label: "Iniciar", variantStyle: .primary, action: {
                flow.goTo(.liveRun)
            })
            
        }
        .padding()
    }
}

#Preview {
    StartTrainingView(targetPace: AppContainer.defaultTargetPace)
        .environment(RunFlowState())
}

