//
//  StatTextComponent.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 19/08/26.
//

import SwiftUI

struct StatTextComponent: View {
    var value: String
    var label: String
    var metric: Metric

    var body: some View {
        VStack(alignment: .center, spacing: -2) {
            Text(metric.value)
                .foregroundStyle(Color.textPrimary)
                .font(AppTypography.title3)
            Text(label)
                .foregroundStyle(Color.textDisable)
                .font(AppTypography.caption)
        }
    }
}

#Preview {
    StatTextComponent(
        value: "54:32",
        label: "TEMPO",
        metric: .duration(seconds: 3000)
    )
}
