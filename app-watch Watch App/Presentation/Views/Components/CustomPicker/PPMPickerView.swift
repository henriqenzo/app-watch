//
//  PPMPickerView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 27/08/26.
//

import SwiftUI

struct PPMPickerView: View {
    @Binding var ppm: Int

    private let ppmRange = Array(Int(MetronomeManager.minPPM)...Int(MetronomeManager.maxPPM))

    @State private var crownValue: Double = 0
    @FocusState private var isPickerFocused: Bool

    var body: some View {
        WheelColumnView(
            values: ppmRange,
            selection: $ppm,
            isFocused: true
        ) { value in
            Text("\(value)")
                .font(.system(size: 26, weight: .semibold, design: .rounded).monospacedDigit())
        }
        .frame(height: 90)
        .focusable()
        .focused($isPickerFocused)
        .digitalCrownRotation(
            $crownValue,
            from: Double(ppmRange.first ?? 40),
            through: Double(ppmRange.last ?? 240),
            by: 1,
            sensitivity: .medium,
            isContinuous: false,
            isHapticFeedbackEnabled: true
        )
        .onChange(of: crownValue) { _, newVal in
            let idx = max(ppmRange.first ?? 40, min(ppmRange.last ?? 240, Int(newVal.rounded())))
            if ppm != idx { ppm = idx }
        }
        .onChange(of: ppm) { _, val in
            crownValue = Double(val)
        }
        .onAppear {
            crownValue = Double(ppm)
            isPickerFocused = true
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var ppm: Int = 160

        var body: some View {
            PPMPickerView(ppm: $ppm)
        }
    }
    return PreviewWrapper()
}
