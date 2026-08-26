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
        .duration(interval: TimeInterval())
    ]
    var onFinish: () -> Void = {}
 
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Estatísticas")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: AppSizes.medium) {
                    ForEach(metrics.indices, id: \.self) { index in
                        StatRowComponent(metric: metrics[index])
                    }
                }
                .padding(.bottom, AppSizes.medium)
                .padding(.top)
                
            }
         
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    onFinish()
                } label: {
                    Image(systemName: "checkmark")
                }
                .tint(.brandPrimary)
            }
        }
        .toolbar(.visible, for: .navigationBar)

    }
}
 
#Preview {
    SummaryView()
}
