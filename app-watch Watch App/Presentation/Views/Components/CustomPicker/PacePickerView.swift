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

    @State private var focusedColumn: Column? = .minutes

    var body: some View {
        HStack(spacing: 0) {
            WheelColumnView(
                values: minutesRange,
                selection: $minutes,
                suffix: "'",
                isFocused: focusedColumn == .minutes
            ) { m in
                Text("\(m)")
                    .font(.system(size: 26, weight: .semibold, design: .rounded).monospacedDigit())
            }
            .onTapGesture { focusedColumn = .minutes }
            .frame(maxWidth: .infinity)

            WheelColumnView(
                values: secondsRange,
                selection: $seconds,
                suffix: "\"",
                isFocused: focusedColumn == .seconds
            ) { s in
                Text(String(format: "%02d", s))
                    .font(.system(size: 26, weight: .semibold, design: .rounded).monospacedDigit())
            }
            .onTapGesture { focusedColumn = .seconds }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 90)
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
