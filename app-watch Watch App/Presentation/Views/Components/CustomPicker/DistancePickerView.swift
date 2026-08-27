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
    
    // Índice cacheado — evita busca linear e evita erro de ponto flutuante
    // ao comparar Double por igualdade exata.
    @State private var kmIndex: Int = 0
    @State private var meterIndex: Int = 0
    
    private var kmSelection: Binding<Double> {
        Binding(
            get: { kmOptions[kmIndex] },   // sempre exato, vem direto do array
            set: { newKm in
                if let idx = kmOptions.firstIndex(of: newKm) {
                    kmIndex = idx
                } else {
                    kmIndex = kmOptions.enumerated()
                        .min(by: { abs($0.element - newKm) < abs($1.element - newKm) })?.offset ?? kmIndex
                }
                meters = kmOptions[kmIndex] * 1000
            }
        )
    }
    
    private var meterSelection: Binding<Int> {
        Binding(
            get: { meterOptions[meterIndex] },
            set: { newM in
                if let idx = meterOptions.firstIndex(of: newM) {
                    meterIndex = idx
                } else {
                    meterIndex = meterOptions.enumerated()
                        .min(by: { abs($0.element - newM) < abs($1.element - newM) })?.offset ?? meterIndex
                }
                meters = Double(meterOptions[meterIndex])
            }
        )
    }
    
    private var crownMax: Double {
        unit == .kilometers ? Double(kmOptions.count - 1) : Double(meterOptions.count - 1)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 6) {
                unitButton(.kilometers)
                unitButton(.meters)
            }
            
            Group {
                if unit == .kilometers {
                    WheelColumnView(values: kmOptions, selection: kmSelection, suffix: "km", isFocused: true) { km in
                        Text(String(format: "%.1f", km))
                            .font(.system(size: 24, weight: .semibold, design: .rounded).monospacedDigit())
                    }
                } else {
                    WheelColumnView(values: meterOptions, selection: meterSelection, suffix: "m", isFocused: true) { m in
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
            $crownValue, from: 0, through: crownMax, by: 1,
            sensitivity: .medium, isContinuous: false, isHapticFeedbackEnabled: true
        )
        .onChange(of: crownValue) { _, newVal in
            let idx = max(0, min(Int(crownMax), Int(newVal.rounded())))
            if unit == .kilometers {
                kmIndex = idx
                meters = kmOptions[idx] * 1000
            } else {
                meterIndex = idx
                meters = Double(meterOptions[idx])
            }
        }
        .onChange(of: meters) { _, _ in
         
            let idx = unit == .kilometers ? kmIndex : meterIndex
            if crownValue != Double(idx) {
                crownValue = Double(idx)
            }
        }
        .onChange(of: unit) { _, _ in
            syncIndicesFromMeters()
            crownValue = Double(unit == .kilometers ? kmIndex : meterIndex)
        }
        .onAppear {
            syncIndicesFromMeters()
            crownValue = Double(unit == .kilometers ? kmIndex : meterIndex)
            isPickerFocused = true
        }
    }
    
    private func syncIndicesFromMeters() {
        let km = meters / 1000
        kmIndex = kmOptions.enumerated().min(by: { abs($0.element - km) < abs($1.element - km) })?.offset ?? 0
        let m = Int(meters.rounded())
        meterIndex = meterOptions.enumerated().min(by: { abs($0.element - m) < abs($1.element - m) })?.offset ?? 0
    }
    
    @ViewBuilder
    private func unitButton(_ option: DistanceUnit) -> some View {
        Button {
            unit = option
            switch option {
            case .kilometers: kmIndex = 0; meters = kmOptions[0] * 1000
            case .meters:     meterIndex = 0; meters = Double(meterOptions[0])
            }
        } label: {
            Text(option.rawValue)
                .font(.system(size: 20, weight: .semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
        .background(Capsule().fill(unit == option ? Color.white.opacity(0.30) : Color.white.opacity(0.06)))
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
