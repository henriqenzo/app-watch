//
//  SelectDurationView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

import SwiftUI

struct SelectDurationView: View {
    @Environment(Router.self) private var router

    @State var hours: Int = 0
    @State var minutes: Int = 0
    
    var body: some View {
        VStack {
            VStack(spacing: 2) {
//                Text("Duração")
//                    .textCase(.uppercase)
//                    .font(.system(size: 11, weight: .semibold))
//                    .foregroundStyle(.pink)
//                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Gire a coroa para selecionar")
                    .font(AppTypography.caption)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            DurationPickerView(hours: $hours, minutes: $minutes)
                .scaleEffect(0.7)
            
            Spacer()
            
            PrimaryButtonComponent(label: "Continuar", variantStyle: .primary, action: {
                router.goTo(.startTraining)
            })
        }
        .navigationTitle("Duração")

    }
}

#Preview {
    SelectDurationView()
}
