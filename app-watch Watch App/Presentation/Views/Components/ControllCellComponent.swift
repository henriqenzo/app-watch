//
//  ControllCellComponent.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 20/08/26.
//

import SwiftUI

struct ControllCellComponent: View {
    let title: String
    let variant: ControlButtonVariant
    let action: () -> Void

    var body: some View {
        VStack(spacing: AppSizes.small) {
            ControlButtonComponent(action: action, variantStyle: variant)
            Text(title)
                .font(AppTypography.caption)
        }
    }
}

#Preview {
    ControllCellComponent(
        title: "Pausar",
        variant: .pause,
        action: {
            print("Pause")
        }
    )
}
