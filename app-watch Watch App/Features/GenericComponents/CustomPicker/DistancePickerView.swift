//
//  DistancePickerView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 19/08/26.
//

import SwiftUI

struct DistancePickerView: View {
    @Binding var meters: Double
    @Binding var unit: DistanceUnit

    private let kmOptions: [Double] = stride(from: 0.5, through: 50, by: 0.1)
        .map { ($0 * 10).rounded() / 10 }

    private let meterOptions: [Int] = Array(stride(from: 100, through: 50000, by: 50))

    private var kmSelection: Binding<Double> {
        Binding(
            get: {
                let km = meters / 1000
                return kmOptions.min(by: { abs($0 - km) < abs($1 - km) }) ?? kmOptions[0]
            },
            set: { newKm in meters = newKm * 1000 }
        )
    }

    private var meterSelection: Binding<Int> {
        Binding(
            get: {
                let m = Int(meters.rounded())
                return meterOptions.min(by: { abs($0 - m) < abs($1 - m) }) ?? meterOptions[0]
            },
            set: { newM in meters = Double(newM) }
        )
    }

    var body: some View {
        VStack(spacing: 6) {
            UnitToggleView(unit: $unit)

            Group {
                if unit == .kilometers {
                    WheelColumnView(values: kmOptions, selection: kmSelection) { km in
                        Text(String(format: "%.1f", km))
                            .font(.system(size: 24, weight: .semibold, design: .rounded).monospacedDigit())
                    }
                } else {
                    WheelColumnView(values: meterOptions, selection: meterSelection) { m in
                        Text("\(m)")
                            .font(.system(size: 24, weight: .semibold, design: .rounded).monospacedDigit())
                    }
                }
            }
            .frame(maxHeight: 80)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var meters: Double = 500
        @State var unit: DistanceUnit = .kilometers

        var body: some View {
            DistancePickerView(meters: $meters, unit: $unit)
        }
    }
    return PreviewWrapper()
}
