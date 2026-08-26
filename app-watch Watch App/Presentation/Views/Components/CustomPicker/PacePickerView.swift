//
//  PacePickerView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 19/08/26.
//

import SwiftUI

struct PacePickerView: View {
    @Binding var minutes: Int
    @Binding var seconds: Int

    private let minutesRange = Array(0...30)
    private let secondsRange = Array(0...59)

    private enum Column: Hashable {
        case minutes, seconds
    }

    @State private var activeColumn: Column = .minutes
    @State private var crownValue: Double = 0
    @FocusState private var isPickerFocused: Bool

    private var crownMax: Double {
        switch activeColumn {
        case .minutes: return Double(minutesRange.count - 1)
        case .seconds: return Double(secondsRange.count - 1)
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            WheelColumnView(
                values: minutesRange,
                selection: $minutes,
                suffix: "'",
                isFocused: activeColumn == .minutes
            ) { m in
                Text("\(m)")
                    .font(.system(size: 26, weight: .semibold, design: .rounded).monospacedDigit())
            }
            .onTapGesture { switchColumn(.minutes) }
            .frame(maxWidth: .infinity)

            WheelColumnView(
                values: secondsRange,
                selection: $seconds,
                suffix: "\"",
                isFocused: activeColumn == .seconds
            ) { s in
                Text(String(format: "%02d", s))
                    .font(.system(size: 26, weight: .semibold, design: .rounded).monospacedDigit())
            }
            .onTapGesture { switchColumn(.seconds) }
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
            switch activeColumn {
            case .minutes:
                if minutes != idx { minutes = idx }
            case .seconds:
                if seconds != idx { seconds = idx }
            }
        }
        .onChange(of: minutes) { _, val in
            if activeColumn == .minutes { crownValue = Double(val) }
        }
        .onChange(of: seconds) { _, val in
            if activeColumn == .seconds { crownValue = Double(val) }
        }
        .onAppear {
            syncCrown()
            isPickerFocused = true
        }
    }

    private func switchColumn(_ column: Column) {
        switch column {
        case .minutes: crownValue = Double(minutes)
        case .seconds: crownValue = Double(seconds)
        }
        activeColumn = column
        isPickerFocused = true
    }

    private func syncCrown() {
        switch activeColumn {
        case .minutes: crownValue = Double(minutes)
        case .seconds: crownValue = Double(seconds)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var minutes: Int = 5
        @State var seconds: Int = 7

        var body: some View {
            PacePickerView(minutes: $minutes, seconds: $seconds)
        }
    }
    return PreviewWrapper()
}
