//
//  SummaryView.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 19/08/26.
//

import SwiftUI

struct SummaryView: View {
    let viewModel: RunViewModelProtocol

    private var metrics: [Metric] {
        [
            .pace(secondsPerKm: viewModel.metricsWorkout.pace),
            .cadence(ppm: viewModel.averageCadence ?? 0),
            .calories(viewModel.metricsWorkout.activeEnergyBurned),
            .duration(interval: viewModel.metricsWorkout.duration),
            .distance(kilometers: viewModel.metricsWorkout.distanceWalkingRunning),
            .heartRate(bpm: viewModel.metricsWorkout.heartRate),
        ]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSizes.medium) {
                ForEach(metrics, id: \.self) { metric in
                    StatRowComponent(metric: metric)
                }
            }
            .padding(.bottom, AppSizes.medium)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var container = AppContainer()

        var body: some View {
            SummaryView(viewModel: container.makeGuideRunViewModel())
        }
    }
    return PreviewWrapper()
}
