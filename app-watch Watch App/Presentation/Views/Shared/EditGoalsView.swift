//
//  EditGoalsView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 27/08/26.
//

import SwiftUI

struct EditGoalsView: View {

    let initialPaceMinutes: Int
    let initialPaceSeconds: Int
    let initialPPM: Int

    let onConfirm: (_ paceMinutes: Int, _ paceSeconds: Int, _ ppm: Int) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var paceMinutes: Int
    @State private var paceSeconds: Int
    @State private var ppm: Int

    init(
        initialPaceMinutes: Int,
        initialPaceSeconds: Int,
        initialPPM: Int,
        onConfirm: @escaping (_ paceMinutes: Int, _ paceSeconds: Int, _ ppm: Int) -> Void
    ) {
        self.initialPaceMinutes = initialPaceMinutes
        self.initialPaceSeconds = initialPaceSeconds
        self.initialPPM = initialPPM
        self.onConfirm = onConfirm

        _paceMinutes = State(initialValue: initialPaceMinutes)
        _paceSeconds = State(initialValue: initialPaceSeconds)
        _ppm        = State(initialValue: initialPPM)
    }

    private var hasChanges: Bool {
        paceMinutes != initialPaceMinutes ||
        paceSeconds != initialPaceSeconds ||
        ppm != initialPPM
    }

    var body: some View {
        TabView {
            paceTab
                .tag(0)

            ppmTab
                .tag(1)
        }
        .tabViewStyle(.page)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: confirm) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(hasChanges ? .pink : .gray.opacity(0.4))
                }
                .disabled(!hasChanges)
            }
        }
    }

    // MARK: - Pace Tab

    private var paceTab: some View {
        VStack(spacing: 4) {
            VStack(spacing: 2) {
                Text("Editar - Pace alvo")
                    .textCase(.uppercase)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.pink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Gire a coroa para selecionar")
                    .font(.system(size: 10))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.gray)
            }

            Spacer()
            
            PacePickerView(minutes: $paceMinutes, seconds: $paceSeconds)
                .scaleEffect(0.8)
            
            Spacer()
        }
        .padding(.horizontal, 4)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.001))
    }

    // MARK: - PPM Tab

    private var ppmTab: some View {
        VStack(spacing: 4) {
            VStack(spacing: 2) {
                Text("Editar - PPM")
                    .textCase(.uppercase)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.pink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Gire a coroa para selecionar")
                    .font(.system(size: 10))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.gray)
            }

            Spacer()

            PPMPickerView(ppm: $ppm)
                .scaleEffect(0.8)

            Spacer()
        }
        .padding(.horizontal, 4)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.001))
    }

    private func confirm() {
        onConfirm(paceMinutes, paceSeconds, ppm)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        EditGoalsView(
            initialPaceMinutes: 5,
            initialPaceSeconds: 30,
            initialPPM: 160
        ) { min, sec, ppm in
            print("Confirmado — Pace: \(min)'\(sec)\" | PPM: \(ppm)")
        }
    }
}
