//
//  UnitToggleView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 19/08/26.
//

import SwiftUI

struct UnitToggleView: View {
    @Binding var unit: DistanceUnit

    var body: some View {
        HStack(spacing: 6) {
            ForEach(DistanceUnit.allCases) { option in
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
            }
        }
        .frame(height: 24)
        .animation(.easeInOut(duration: 0.15), value: unit)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var unit: DistanceUnit = .kilometers

        var body: some View {
            UnitToggleView(unit: $unit)
        }
    }
    return PreviewWrapper()
}
