//
//  ResultView.swift
//  app-watch Watch App
//
//  Created by Filipi Romão on 19/08/26.
//

import SwiftUI
 
struct SummaryView: View {
    var metrics: [Metric] = [
        .pace(secondsPerKm: 332),
        .calories(615),
        .distance(kilometers: 5.42),
        .duration(seconds: 1802)
    ]
   
 
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSizes.medium) {
                ForEach(metrics.indices, id: \.self) { index in
                    StatRowComponent(metric: metrics[index])
                }
            }
            .padding(.bottom, AppSizes.medium)
        }
    }
}
 
#Preview {
    SummaryView()
}
