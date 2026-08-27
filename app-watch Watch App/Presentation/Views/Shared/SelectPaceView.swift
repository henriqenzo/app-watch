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
    SelectPaceView()
}
