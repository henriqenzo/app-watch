//
//  StatTextComponent.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 19/08/26.
//

import SwiftUI

struct StatTextComponent: View {
    var metric: Metric

    var body: some View {
        VStack(alignment: .center, spacing: -2) {
            Text(metric.value)
                .foregroundStyle(Color.textPrimary)
                .font(AppTypography.title3)
            Text(metric.label)
                .foregroundStyle(Color.textDisable)
                .font(AppTypography.caption)
        }
    }
}

#Preview {
    StatTextComponent(
        metric: .duration(interval: 3000)
    )
}
