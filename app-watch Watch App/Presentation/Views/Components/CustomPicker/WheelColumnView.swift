//
//  WheelColumnView.swift
//  app-watch Watch App
//
//  Created by Enzo Henrique Botelho Romão on 20/08/26.
//

//  Requer watchOS 10+ (scrollPosition/scrollTargetLayout/scrollTargetBehavior).

import SwiftUI

struct WheelColumnView<Value: Hashable>: View {
    let values: [Value]
    @Binding var selection: Value
    /// Sufixo exibido SOMENTE no item selecionado (ex: "'" para minutos, "\"" para segundos).
    var suffix: String? = nil
    /// Quando `true`, desenha o highlight e conecta a Digital Crown a esta coluna.
    var isFocused: Bool = false
    let label: (Value) -> Text

    private let rowHeight: CGFloat = 32

    // Crown rotation: valor contínuo mapeado para o índice no array.
    @State private var crownValue: Double = 0

    private var currentIndex: Int {
        values.firstIndex(of: selection) ?? 0
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(values, id: \.self) { value in
                    let isSelected = value == selection

                    HStack(alignment: .lastTextBaseline, spacing: 1) {
                        label(value)
                        if let suffix, isSelected {
                            Text(suffix)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundStyle(.white)
                        }
                    }
                    .foregroundStyle(isSelected ? Color.white : Color.secondary.opacity(0.45))
                    .fontWeight(isSelected ? .bold : .regular)
                    .frame(height: rowHeight)
                    .frame(maxWidth: .infinity)
                    .background {
                        if isFocused && isSelected {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.white.opacity(0.12))
                        }
                    }
                    .id(value)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(
            id: Binding(
                get: { Optional(selection) },
                set: { if let newValue = $0 { selection = newValue } }
            )
        )
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
        .frame(height: rowHeight * 3)
        .safeAreaPadding(.vertical, rowHeight)
        // Limita hit-testing ao frame visível — impede que o safeAreaPadding
        // intercepte toques em views acima/abaixo (ex: UnitToggleView).
        .contentShape(Rectangle())
        .clipped()
        .mask(
            LinearGradient(
                stops: [
                    .init(color: .clear,               location: 0),
                    .init(color: .clear,               location: 0.14),
                    .init(color: .black.opacity(0.35), location: 0.28),
                    .init(color: .black,               location: 0.38),
                    .init(color: .black,               location: 0.62),
                    .init(color: .black.opacity(0.45), location: 0.74),
                    .init(color: .black.opacity(0.15), location: 0.88),
                    .init(color: .clear,               location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        // Digital Crown — só conectada quando esta coluna está focada.
        // Ao receber foco, o crownValue é re-sincronizado para o índice atual,
        // garantindo que a crown retome do ponto certo mesmo após trocar de coluna.
        .modifier(CrownRotationModifier(
            isFocused: isFocused,
            crownValue: $crownValue,
            count: values.count
        ))
        .onChange(of: crownValue) { _, newVal in
            let idx = max(0, min(values.count - 1, Int(newVal.rounded())))
            selection = values[idx]
        }
        // Sincroniza crownValue quando a seleção muda por toque/scroll.
        .onChange(of: selection) { _, _ in
            crownValue = Double(currentIndex)
        }
        // Sincroniza ao aparecer e ao receber foco.
        .onAppear {
            crownValue = Double(currentIndex)
        }
        .onChange(of: isFocused) { _, focused in
            if focused {
                crownValue = Double(currentIndex)
            }
        }
    }
}

// MARK: - CrownRotationModifier
// Aplica .digitalCrownRotation apenas quando isFocused == true,
// evitando que duas colunas compitam pelo controle da crown ao mesmo tempo.
private struct CrownRotationModifier: ViewModifier {
    let isFocused: Bool
    @Binding var crownValue: Double
    let count: Int

    func body(content: Content) -> some View {
        if isFocused {
            content
                .digitalCrownRotation(
                    $crownValue,
                    from: 0,
                    through: Double(count - 1),
                    by: 1,
                    sensitivity: .medium,
                    isContinuous: false,
                    isHapticFeedbackEnabled: true
                )
        } else {
            content
        }
    }
}
