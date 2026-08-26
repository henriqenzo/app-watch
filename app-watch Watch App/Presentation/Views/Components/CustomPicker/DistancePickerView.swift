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

    @State private var crownValue: Double = 0
    @FocusState private var isPickerFocused: Bool

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

    private var currentIndex: Int {
        if unit == .kilometers {
            let km = meters / 1000
            return kmOptions.enumerated()
                .min(by: { abs($0.element - km) < abs($1.element - km) })?.offset ?? 0
        } else {
            let m = Int(meters.rounded())
            return meterOptions.enumerated()
                .min(by: { abs($0.element - m) < abs($1.element - m) })?.offset ?? 0
        }
    }

    private var crownMax: Double {
        if unit == .kilometers {
            return Double(kmOptions.count - 1)
        } else {
            return Double(meterOptions.count - 1)
        }
    }

    var body: some View {
        HStack(spacing: 8) {
            // Botões de unidade empilhados à esquerda da coluna
            VStack(spacing: 6) {
                unitButton(.kilometers)
                unitButton(.meters)
            }

            // Coluna de seleção
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
            .frame(maxWidth: .infinity)
        }
        .frame(height: 90)
        .focusable()
        .focused($isPickerFocused)
        .digitalCrownRotation(
            $crownValue,
            from: 0,
            through: crownMax,
            by: 1,
            sensitivity: .medium,
            isContinuous: false,
            isHapticFeedbackEnabled: true
        )
        .onChange(of: crownValue) { _, newVal in
            let idx = max(0, min(Int(crownMax), Int(newVal.rounded())))
            if unit == .kilometers {
                meters = kmOptions[idx] * 1000
            } else {
                meters = Double(meterOptions[idx])
            }
        }
        .onChange(of: meters) { _, _ in
            crownValue = Double(currentIndex)
        }
        .onChange(of: unit) { _, _ in
            crownValue = Double(currentIndex)
        }
        .onAppear {
            crownValue = Double(currentIndex)
            isPickerFocused = true
        }
    }

    @ViewBuilder
    private func unitButton(_ option: DistanceUnit) -> some View {
        Button {
            unit = option
        } label: {
            Text(option.rawValue)
                .font(.system(size: 13, weight: .semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
        .background(
            Capsule()
                .fill(unit == option ? Color.white.opacity(0.30) : Color.white.opacity(0.06))
        )
        .foregroundStyle(unit == option ? Color.white : Color.secondary.opacity(0.7))
        .animation(.easeInOut(duration: 0.15), value: unit)
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
