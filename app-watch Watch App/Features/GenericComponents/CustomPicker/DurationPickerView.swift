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

    @State private var focusedColumn: Column? = .minutes

    var body: some View {
        HStack(spacing: 0) {
            // Label "hrs" à esquerda da coluna de horas
            Text("hrs")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary.opacity(0.6))
                .frame(width: 24)

            WheelColumnView(values: hoursRange, selection: $hours, isFocused: focusedColumn == .hours) { h in
                Text("\(h)")
                    .font(.system(size: 26, weight: .semibold, design: .rounded).monospacedDigit())
            }
            .onTapGesture { focusedColumn = .hours }
            .frame(maxWidth: .infinity)

            WheelColumnView(values: minutesRange, selection: $minutes, isFocused: focusedColumn == .minutes) { m in
                Text(String(format: "%02d", m))
                    .font(.system(size: 26, weight: .semibold, design: .rounded).monospacedDigit())
            }
            .onTapGesture { focusedColumn = .minutes }
            .frame(maxWidth: .infinity)

            // Label "min" à direita da coluna de minutos
            Text("min")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary.opacity(0.6))
                .frame(width: 24)
        }
        .frame(height: 90)
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
