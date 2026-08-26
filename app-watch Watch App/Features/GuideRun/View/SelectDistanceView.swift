//
//  SelectDistanceView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

import SwiftUI

struct SelectDistanceView: View {
    @Environment(Router.self) private var router
    @State var meters: Double = 0
    @State var unit: DistanceUnit = .kilometers
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
//                Text("Distância")
//                    .textCase(.uppercase)
//                    .font(.system(size: 11, weight: .semibold))
//                    .foregroundStyle(.pink)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                
                Text("Gire a coroa para selecionar")
                    .font(AppTypography.caption)
                    .foregroundStyle(.gray)
            }
            
            DistancePickerView(meters: $meters, unit: $unit)
                .scaleEffect(0.7)
            
            PrimaryButtonComponent(label: "Continuar", variantStyle: .primary, action: { router.goTo(.selectTime)})
        }
        .padding()
        .navigationTitle("Distância")

    }
}

#Preview {
    SelectDistanceView()
}
