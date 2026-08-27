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
                    router.goTo(.startTraining)
                    
                } label: {
                    Image(systemName: "checkmark")
                }
                .tint(.brandPrimary)
            }
        }
        .padding()
    }
}

#Preview {
    SelectDurationView()
}
