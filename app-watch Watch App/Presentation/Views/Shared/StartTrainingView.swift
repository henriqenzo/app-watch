//
//  StartTrainingView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

import SwiftUI

struct StartTrainingView: View {
    let targetPace: Int

    private var targetPaceLabel: String {
        FormatMinutes.pace(targetPace) + "/km"
    }

    var body: some View {
        VStack {
            Text("Pronto para começar?")
                .font(.system(size: 12, weight: .semibold))
            
            Spacer()
            
            VStack(spacing: 8) {
                VStack {
                    Text("PPM inicial")
                        .font(.system(size: 11))
                        .foregroundStyle(.gray)
                    
                    Text("170")
                        .font(.system(size: 35, weight: .semibold))
                        .foregroundStyle(.pink)
                    
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
            
            Button(action: {
                // continue
            }) {
                Text("Iniciar")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 35)
                    .background(.pink)
                    .cornerRadius(12)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    StartTrainingView(targetPace: AppContainer.defaultTargetPace)
}
