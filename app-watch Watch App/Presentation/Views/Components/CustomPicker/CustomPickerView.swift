//
//  CustomPickerView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 19/08/26.
//

import SwiftUI

enum DistanceUnit: String, CaseIterable, Identifiable {
    case kilometers = "km"
    case meters = "m"

    var id: String { rawValue }
}

enum GoalPickerMode {
    case pace(minutes: Binding<Int>, seconds: Binding<Int>)
    case distance(meters: Binding<Double>, unit: Binding<DistanceUnit>)
    case duration(hours: Binding<Int>, minutes: Binding<Int>)
    case ppm(value: Binding<Int>)
}

struct CustomPickerView: View {
    let title: String
    let mode: GoalPickerMode

    var body: some View {
        VStack(spacing: 2) {
            Text(title.uppercased())
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .tracking(0.5)

            switch mode {
            case .pace(let minutes, let seconds):
                PacePickerView(minutes: minutes, seconds: seconds)
            case .distance(let meters, let unit):
                DistancePickerView(meters: meters, unit: unit)
            case .duration(let hours, let minutes):
                DurationPickerView(hours: hours, minutes: minutes)
            case .ppm(let value):
                PPMPickerView(ppm: value)
            }
        }
    }
}

#Preview {
    CustomPickerView(title: "Picker", mode: .pace(minutes: .constant(0), seconds: .constant(0)))
}

