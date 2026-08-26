//
//  DurationPickerView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 19/08/26.
//

import SwiftUI

struct DurationPickerView: View {
    @Binding var hours: Int
    @Binding var minutes: Int

    private let hoursRange = Array(0...23)
    private let minutesRange = Array(0...59)

    private enum Column: Hashable {
        case hours, minutes
    }

    @State private var activeColumn: Column = .minutes
    @State private var crownValue: Double = 0
    @FocusState private var isPickerFocused: Bool

    private var crownMax: Double {
        switch activeColumn {
        case .hours: return Double(hoursRange.count - 1)
        case .minutes: return Double(minutesRange.count - 1)
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            // Label "hrs" à esquerda da coluna de horas
            Text("hrs")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary.opacity(0.6))
                .frame(width: 24)

            WheelColumnView(values: hoursRange, selection: $hours, isFocused: activeColumn == .hours) { h in
                Text("\(h)")
                    .font(.system(size: 26, weight: .semibold, design: .rounded).monospacedDigit())
            }
            .onTapGesture { switchColumn(.hours) }
            .frame(maxWidth: .infinity)

            WheelColumnView(values: minutesRange, selection: $minutes, isFocused: activeColumn == .minutes) { m in
                Text(String(format: "%02d", m))
                    .font(.system(size: 26, weight: .semibold, design: .rounded).monospacedDigit())
            }
            .onTapGesture { switchColumn(.minutes) }
            .frame(maxWidth: .infinity)

            // Label "min" à direita da coluna de minutos
            Text("min")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary.opacity(0.6))
                .frame(width: 24)
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
            switch activeColumn {
            case .hours:
                if hours != idx { hours = idx }
            case .minutes:
                if minutes != idx { minutes = idx }
            }
        }
        // Sincroniza crownValue quando o valor muda por toque/scroll
        .onChange(of: hours) { _, val in
            if activeColumn == .hours { crownValue = Double(val) }
        }
        .onChange(of: minutes) { _, val in
            if activeColumn == .minutes { crownValue = Double(val) }
        }
        .onAppear {
            syncCrown()
            isPickerFocused = true
        }
    }

    private func switchColumn(_ column: Column) {
        // Sincroniza o crown ANTES de trocar a coluna para evitar
        // que o framework clamp crownValue ao novo range antes de eu setar.
        switch column {
        case .hours: crownValue = Double(hours)
        case .minutes: crownValue = Double(minutes)
        }
        activeColumn = column
        isPickerFocused = true
    }

    private func syncCrown() {
        switch activeColumn {
        case .hours: crownValue = Double(hours)
        case .minutes: crownValue = Double(minutes)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var hours: Int = 0
        @State var minutes: Int = 24

        var body: some View {
            DurationPickerView(hours: $hours, minutes: $minutes)
        }
    }
    return PreviewWrapper()
}
