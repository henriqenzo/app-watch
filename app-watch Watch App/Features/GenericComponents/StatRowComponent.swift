//
//  StatRowComponent.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 19/08/26.
//

import SwiftUI

struct StatRowComponent: View {
    var metric: Metric

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(metric.label)
                .font(AppTypography.caption)
                .foregroundStyle(Color.textDisable)

            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text(metric.value)
                    .font(AppTypography.title1)
                    .foregroundStyle(Color.brandPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Text(metric.description)
                    .font(AppTypography.title3)
                    .foregroundStyle(Color.textDisable)

            }
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(.gray.opacity(0.3))
        }
        .frame(maxWidth: .infinity, alignment: .leading)

    }
}

#Preview {
    VStack(alignment: .leading, spacing: AppSizes.medium) {
        StatRowComponent(metric: .pace(secondsPerKm: 332))
        StatRowComponent(metric: .distance(kilometers: 5.42))
        StatRowComponent(metric: .calories(160))
    }
    .padding(.horizontal, AppSizes.medium)
}
