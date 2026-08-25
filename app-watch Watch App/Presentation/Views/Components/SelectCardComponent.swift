//
//  SelectCardComponent.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 19/08/26.
//

import SwiftUI

struct SelectCardComponent: View {
    var icon: String = "star.fill"
    var title: String
    var subtitle: String
    var selected: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSizes.medium) {
                Image(systemName: icon)
                    .font(AppTypography.subheadlineSemibold)
                    .foregroundStyle(
                        selected ? Color.brandPrimary : Color.textSecondary
                    )

                VStack(alignment: .leading) {
                    Text(title)
                        .font(AppTypography.subheadlineSemibold)
                        .foregroundStyle(Color.textPrimary)

                    Text(subtitle)
                        .font(AppTypography.caption)
                        .foregroundStyle(Color.textSecondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                }

            }
            .padding(AppSizes.medium)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.backgroundLight)
            .cornerRadius(AppRadius.buttonRadius)
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.buttonRadius)
                    .stroke(
                        selected ? Color.brandPrimary : .clear,
                        lineWidth: 2
                    )
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var choice = 1

    VStack(spacing: AppSizes.medium) {
        SelectCardComponent(
            title: "Pace alvo",
            subtitle: "Meta de pace",
            selected: choice == 0,
            action: { choice = 0 }
        )
        SelectCardComponent(
            icon: "metronome.fill",
            title: "Distância e tempo",
            subtitle: "Meta de distância e tempo",
            selected: choice == 1,
            action: { choice = 1 }
        )
    }
}
