//
//  PrimaryButton.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 19/08/26.
//

import SwiftUI

enum ButtonVariant {
    case primary
    case secondary

    var background: Color {
        switch self {
        case .primary: return Color.brandPrimary
        case .secondary: return Color.backgroundLight
        }
    }
    var foreground: Color {
        switch self {
        case .primary: return Color.textDark
        case .secondary: return Color.textPrimary
        }
    }

}

struct PrimaryButtonComponent: View {
    var label: String
    var variantStyle: ButtonVariant = .primary
    var action: () -> Void

    var body: some View {
        Button(
            action: action,
            label: {
                Text(label)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(variantStyle.foreground)
                    .font(AppTypography.subheadlineSemibold)
            }
        )
        .frame(height: 38)
        .background(variantStyle.background)
        .cornerRadius(AppRadius.buttonRadius)
        .buttonStyle(.plain)
    }

}

#Preview {
    PrimaryButtonComponent(label: "Iniciar", variantStyle:  .primary) {
        print("Oi")
    }
}
