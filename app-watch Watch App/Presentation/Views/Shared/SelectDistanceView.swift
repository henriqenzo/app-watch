//
//  SelectDistanceView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

import SwiftUI

struct SelectDistanceView: View {
    
    @State var meters: Double = 0
    @State var unit: DistanceUnit = .kilometers
    
    var body: some View {
        VStack {
            VStack(spacing: 2) {
                Text("Distância")
                    .textCase(.uppercase)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.pink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Gire a coroa para selecionar")
                    .font(.system(size: 10))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            DistancePickerView(meters: $meters, unit: $unit)
                .scaleEffect(0.7)
            
            Spacer()
            
            Button(action: {
                // continue
            }) {
                Text("Continuar")
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
    SelectDistanceView()
}
