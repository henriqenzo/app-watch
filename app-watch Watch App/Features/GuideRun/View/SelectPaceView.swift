//
//  SelectPaceView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

import SwiftUI

struct SelectPaceView: View {
    @Environment(Router.self) private var router
    @State var minutes: Int = 0
    @State var seconds: Int = 0

    var body: some View {
            VStack {
                VStack(spacing: 2) {
                    //                Text("Pace alvo")
                    //                    .textCase(.uppercase)
                    //                    .font(AppTypography.footnote)
                    //                    .fontWeight(.semibold)
                    //                    .foregroundStyle(.brandPrimary)
                    //                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Gire a coroa para selecionar")
                        .font(AppTypography.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.gray)
                }
                
                
                PacePickerView(minutes: $minutes, seconds: $seconds)
                    .scaleEffect(0.7)
                
                
                PrimaryButtonComponent(label: "Continuar", variantStyle: .primary, action: {
                    router.goTo(.startTraining)
                })
            }
        .navigationTitle("Pace alvo")
        .padding()
    }
}

#Preview {
    SelectPaceView()
}
